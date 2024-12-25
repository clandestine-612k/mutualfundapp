import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/Details_Screen/controller/detailscreen_controller.dart';
import 'package:mutualfundapp/models/home_screen_model.dart';
import 'package:mutualfundapp/models/mutual_fund_model.dart';

class DetailsScreen extends StatelessWidget {
  final MutualFund fund;

  const DetailsScreen({Key? key, required this.fund}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MutualFundController2 controller = Get.put(MutualFundController2());
    controller.fetchHistoricalData(fund.schemeCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(fund.schemeName),
      ),
      body: Column(
        children: [
          // Expanded Box 1: Historical Data
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
                        'Date: ${data.date}', // Display formatted date.
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('NAV: ₹${data.nav}'), // Display NAV.
                    ),
                  );
                },
              );
            }),
          ),

          // Expanded Box 2:
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

              // State to manage selected year range by default 1 yr
              final selectedYears = 1.obs;

              // Filter data based on selected years
              List<Data> filteredData() {
                final cutoffDate = DateTime.now()
                    .subtract(Duration(days: selectedYears.value * 365));
                return allData
                    .where((e) => DateTime.parse((e.date!)).isAfter(cutoffDate))
                    .toList();
              }

              return Column(
                children: [
                  // Button Row
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
                                spots: data
                                    .map((e) => FlSpot(
                                          DateTime.parse((e.date!))
                                              .millisecondsSinceEpoch
                                              .toDouble(),
                                          double.tryParse(e.nav!) ?? 0.0,
                                        ))
                                    .toList(),
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
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(
                                          1), // Format the Y-axis value
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
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
                                      '${date.month}/${date.year % 100}', // Format as MM/YY
                                      style: const TextStyle(fontSize: 12),
                                    );
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

          // Expanded Box 3: Gains Calculation
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
                      '1-Year Gain: ${calculateGain(data, 365).toStringAsFixed(2)}%',
                    ),
                    Text(
                      '3-Year Gain: ${calculateGain(data, 365 * 3).toStringAsFixed(2)}%',
                    ),
                    Text(
                      '5-Year Gain: ${calculateGain(data, 365 * 5).toStringAsFixed(2)}%',
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

  double calculateGain(List<Data> data, int days) {
    if (data.isEmpty) return 0.0;

    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));

    // Filter data within the cutoff period
    final relevantData =
        data.where((e) => DateTime.parse(e.date!).isAfter(cutoff)).toList();

    if (relevantData.length < 2) return 0.0;

    final start = double.tryParse(relevantData.last.nav!) ?? 0.0;
    final end = double.tryParse(relevantData.first.nav!) ?? 0.0;

    return ((end - start) / start) * 100;
  }
}
