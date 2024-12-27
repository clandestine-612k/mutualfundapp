import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutualfundapp/data/models/home-screen-model.dart';

class FavoritesController extends GetxController {
  final box = GetStorage();
  RxList<MutualFund> favorites = <MutualFund>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load favorites from GetStorage on initialization
    final storedFavorites = box.read<List>('favorites') ?? [];
    favorites.value = List<MutualFund>.from(storedFavorites);
  }

  void toggleFavorite(MutualFund Fund) {
    if (favorites.contains(Fund)) {
      favorites.remove(Fund);
      Get.snackbar('Removed', 'Removed from favorites');
    } else {
      favorites.add(Fund);
      Get.snackbar('Added', 'Added to favorites');
    }
    box.write('favorites', favorites);
  }

  bool isFavorite(MutualFund fund) {
    return favorites.contains(fund);
  }
}
