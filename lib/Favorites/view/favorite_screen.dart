import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/Favorites/controller/favorite_controller.dart';
import 'package:mutualfundapp/colors.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        title: const Text('Favorites'),
      ),
      body: Obx(() {
        if (favoritesController.favorites.isEmpty) {
          return const Center(
            child: Text('No favorites added yet.'),
          );
        }
        return ListView.builder(
          itemCount: favoritesController.favorites.length,
          itemBuilder: (context, index) {
            final schemeCode = favoritesController.favorites[index];
            return Padding(
              padding: const EdgeInsets.all(11.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black),
                ),
                title: Text('Scheme Code: $schemeCode'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    favoritesController.toggleFavorite(schemeCode);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
