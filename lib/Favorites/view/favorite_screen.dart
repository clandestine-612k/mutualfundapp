import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfundapp/Favorites/controller/favorite_controller.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            return ListTile(
              title: Text('Scheme Code: $schemeCode'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  favoritesController.toggleFavorite(schemeCode);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
