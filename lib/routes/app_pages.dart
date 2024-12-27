import 'package:get/get.dart';
import 'package:mutualfundapp/modules/details-screen/view/details_screen.dart';
import 'package:mutualfundapp/modules/favorites/view/favorite_screen.dart';
import 'package:mutualfundapp/modules/home-screen/view/home_page.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.home, page: () => HomeScreen()),
    GetPage(name: Routes.favouite, page: () => FavoritesScreen()),
    GetPage(name: Routes.details, page: () => const DetailsScreen())
  ];
}
