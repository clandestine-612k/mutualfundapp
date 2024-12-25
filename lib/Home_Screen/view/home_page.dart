import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/Details_Screen/view/details_screen.dart';
import 'package:mutualfundapp/Home_Screen/controller/mutual_fund_controller.dart';

import '../../Favorites/view/favorite_screen.dart';

class HomeScreen extends StatelessWidget {
  final MutualFundController controller = Get.put(MutualFundController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutual Funds App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Get.to(() => FavoritesScreen());
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autocorrect: true,
              onChanged: (query) => controller.filterMutualFunds(query),
              decoration: InputDecoration(
                labelText: 'Search Mutual Funds',
                labelStyle:
                    const TextStyle(color: Colors.black54), // Label color
                filled: true, // Enables background color
                fillColor: Colors.white.withOpacity(1),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
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
                      hoverColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black),
                      ),
                      onTap: () {
                        Get.to(() => DetailsScreen(fund: fund));
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
