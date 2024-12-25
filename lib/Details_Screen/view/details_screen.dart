import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/Details_Screen/controller/detailscreen_controller.dart';
import 'package:mutualfundapp/Favorites/controller/favorite_controller.dart';
import 'package:mutualfundapp/models/home_screen_model.dart';
import 'package:mutualfundapp/models/mutual_fund_model.dart';

class DetailsScreen extends StatelessWidget {
  final MutualFund fund;

  DetailsScreen({Key? key, required this.fund}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MutualFundController2 controller = Get.put(MutualFundController2());
    final FavoritesController favoritesController =
        Get.put(FavoritesController());

    // Fetch the historical data for the mutual fund
    controller.fetchHistoricalData(fund.schemeCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(fund.schemeName),
        actions: [
          Obx(() {
            final isFavorite = favoritesController.isFavorite(fund.schemeCode);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              onPressed: () {
                favoritesController.toggleFavorite(fund.schemeCode);
              },
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Box 1: Historical Data
          Expanded(
            flex: 1,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text('Error: ${controller.errorMessage.value}'),
                );
              }

              if (controller.navData.value == null ||
                  controller.navData.value!.data == null ||
                  controller.navData.value!.data!.isEmpty) {
                return const Center(
                    child: Text('No historical data available.'));
              }

              final historicalData = controller.navData.value!.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: historicalData.length,
                itemBuilder: (context, index) {
                  final data = historicalData[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        'Date: ${data.date}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('NAV: ₹${data.nav}'),
                    ),
                  );
                },
              );
            }),
          ),

          // Box 2: Filtered Historical Data with Chart
          Expanded(
            flex: 2,
            child: Obx(() {
              if (controller.isLoading.value ||
                  controller.navData.value == null ||
                  controller.navData.value!.data == null ||
                  controller.navData.value!.data!.isEmpty) {
                return const Center(
                    child: Text('No data available for the selected period.'));
              }

              final allData = controller.navData.value!.data!;
              final selectedYears = 1.obs;

              List<Datam> filteredData() {
                final cutoffDate = DateTime.now()
                    .subtract(Duration(days: selectedYears.value * 365));
                return allData
                    .where((e) => DateTime.parse(e.date!).isAfter(cutoffDate))
                    .toList();
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => selectedYears.value = 1,
                        child: const Text('1 yr'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedYears.value = 3,
                        child: const Text('3 yr'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedYears.value = 5,
                        child: const Text('5 yr'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      final data = filteredData();
                      if (data.isEmpty) {
                        return const Center(
                            child:
                                Text('No NAV data for the selected period.'));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: data.map((e) {
                                  final date = DateTime.parse(e.date!)
                                      .millisecondsSinceEpoch
                                      .toDouble();
                                  final nav = double.tryParse(e.nav!) ?? 0.0;
                                  return FlSpot(date, nav);
                                }).toList(),
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.toInt());
                                    return Text(
                                        '${date.month}/${date.year % 100}',
                                        style: const TextStyle(fontSize: 12));
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                bottom: BorderSide(color: Colors.grey),
                                left: BorderSide(color: Colors.grey),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }),
          ),

          // Box 3: Gains Calculation
          Expanded(
            flex: 1,
            child: Obx(() {
              if (controller.isLoading.value ||
                  controller.navData.value == null ||
                  controller.navData.value!.data == null ||
                  controller.navData.value!.data!.isEmpty) {
                return const SizedBox.shrink();
              }

              final data = controller.navData.value!.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gains',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '1-Year Gain: ${calculateGain(data, 365).toStringAsFixed(2)}%'),
                    Text(
                        '3-Year Gain: ${calculateGain(data, 365 * 3).toStringAsFixed(2)}%'),
                    Text(
                        '5-Year Gain: ${calculateGain(data, 365 * 5).toStringAsFixed(2)}%'),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  double calculateGain(List<Datam> data, int days) {
    if (data.isEmpty) return 0.0;

    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));

    final relevantData =
        data.where((e) => DateTime.parse(e.date!).isAfter(cutoff)).toList();
    if (relevantData.length < 2) return 0.0;

    final start = double.tryParse(relevantData.last.nav!) ?? 0.0;
    final end = double.tryParse(relevantData.first.nav!) ?? 0.0;

    return ((end - start) / start) * 100;
  }
}
