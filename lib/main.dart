import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutualfundapp/Favorites/controller/favorite_controller.dart';
import 'package:mutualfundapp/Home_Screen/view/home_page.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(FavoritesController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mutual Fund App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
