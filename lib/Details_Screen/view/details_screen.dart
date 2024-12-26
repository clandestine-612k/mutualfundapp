import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/Details_Screen/controller/detailscreen_controller.dart';
import 'package:mutualfundapp/Favorites/controller/favorite_controller.dart';
import 'package:mutualfundapp/colors.dart';
import 'package:mutualfundapp/models/home_screen_model.dart';
import 'package:mutualfundapp/models/mutual_fund_model.dart';

class DetailsScreen extends StatelessWidget {
  final MutualFund fund;

  const DetailsScreen({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    final MutualFundController2 controller = Get.put(MutualFundController2());
    final FavoritesController favoritesController =
        Get.put(FavoritesController());

    // Fetch the historical data for the mutual fund
    controller.fetchHistoricalData(fund.schemeCode);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        title: Text(fund.schemeName),
        actions: [
          Obx(() {
            final isFavorite = favoritesController.isFavorite(fund);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              onPressed: () {
                favoritesController.toggleFavorite(fund);
              },
            );
          }),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          //Box 1: To show historical data
          Expanded(
            flex: 2,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.navData.value == null ||
                  controller.navData.value!.data == null ||
                  controller.navData.value!.data!.isEmpty) {
                return const Center(
                    child: Text('No data available for the selected period.'));
              }

              final allData = controller.navData.value!.data!;

              // Sort data to ensure chronological order
              final sortedData = List<Datam>.from(allData)
                ..sort((a, b) =>
                    DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));

              final selectedYears = 1.obs;

              List<Datam> filteredData() {
                // Set 'now' to the last date in the sorted data
                final now = DateTime.parse(sortedData.last.date!);
                final cutoffDate =
                    now.subtract(Duration(days: selectedYears.value * 365));
                return sortedData
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
                        style:
                            ElevatedButton.styleFrom(backgroundColor: color2),
                        child: const Text('1 yr'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedYears.value = 3,
                        style:
                            ElevatedButton.styleFrom(backgroundColor: color2),
                        child: const Text('3 yr'),
                      ),
                      ElevatedButton(
                        onPressed: () => selectedYears.value = 5,
                        style:
                            ElevatedButton.styleFrom(backgroundColor: color2),
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
                                      .difference(DateTime.parse(
                                          sortedData.first.date!))
                                      .inDays
                                      .toDouble(); // Use days since the first date
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
                                    final firstDate =
                                        DateTime.parse(sortedData.first.date!);
                                    final date = firstDate
                                        .add(Duration(days: value.toInt()));
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

          // Box 2: Gains Calculation
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
                    Row(
                      children: [
                        Card(
                          color: color2,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, bottom: 20.0, left: 8, right: 8),
                            child: Text(
                                '1-Year Gain: ${calculateGain(data, 365).toStringAsFixed(2)}%'),
                          ),
                        ),
                        Card(
                          color: color2,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, bottom: 20, left: 8, right: 8),
                            child: Text(
                                '3-Year Gain: ${calculateGain(data, 365 * 3).toStringAsFixed(2)}%'),
                          ),
                        ),
                        Card(
                          color: color2,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, bottom: 20.0, left: 8, right: 8),
                            child: Text(
                                '5-Year Gain: ${calculateGain(data, 365 * 5).toStringAsFixed(2)}%'),
                          ),
                        ),
                      ],
                    ),
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

    // Sort the data to ensure chronological order
    final sortedData = List<Datam>.from(data)
      ..sort(
          (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));

    // Use the first date in the data as 'now'
    final now = DateTime.parse(sortedData.last.date!);
    final cutoff = now.subtract(Duration(days: days));

    // Filter data based on the cutoff
    final relevantData = sortedData
        .where((e) => DateTime.parse(e.date!).isAfter(cutoff))
        .toList();

    if (relevantData.length < 2) return 0.0;

    final startNav = double.tryParse(relevantData.last.nav!) ?? 0.0;
    final endNav = double.tryParse(relevantData.first.nav!) ?? 0.0;

    if (startNav == 0.0) return 0.0;

    return ((endNav - startNav) / startNav) * 100;
  }
}
