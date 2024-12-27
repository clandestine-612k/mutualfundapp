import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/modules/home-screen/controller/mutual_fund_controller.dart';
import 'package:mutualfundapp/routes/app_pages.dart';
import 'package:mutualfundapp/themes/colors.dart';

class HomeScreen extends StatelessWidget {
  final MutualFundController controller = Get.put(MutualFundController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        title: const Text('Mutual Funds App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Get.toNamed(Routes.favouite);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: true,
                onChanged: (query) => controller.filterMutualFunds(query),
                decoration: const InputDecoration(
                  labelText: 'Search Mutual Funds',
                  labelStyle: TextStyle(color: Colors.black54), // Label color
                  filled: true, // Enables background color
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.black54),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.mutualFunds.isEmpty) {
                // Show message if no data is available
                return const Center(
                  child: Text(
                    'No mutual funds data available.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.mutualFunds.length,
                itemBuilder: (context, index) {
                  final fund = controller.mutualFunds[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(fund.schemeName),
                      subtitle: Text('Scheme Code: ${fund.schemeCode}'),
                      hoverColor: color2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black),
                      ),
                      onTap: () {
                        Get.toNamed(Routes.details, arguments: fund);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
