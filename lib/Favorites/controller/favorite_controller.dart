import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoritesController extends GetxController {
  final box = GetStorage();
  RxList<int> favorites = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load favorites from GetStorage on initialization
    final storedFavorites = box.read<List>('favorites') ?? [];
    favorites.value = List<int>.from(storedFavorites);
  }

  void toggleFavorite(int schemeCode) {
    if (favorites.contains(schemeCode)) {
      favorites.remove(schemeCode);
      Get.snackbar('Removed', 'Removed from favorites');
    } else {
      favorites.add(schemeCode);
      Get.snackbar('Added', 'Added to favorites');
    }
    box.write('favorites', favorites);
  }

  bool isFavorite(int schemeCode) {
    return favorites.contains(schemeCode);
  }
}
