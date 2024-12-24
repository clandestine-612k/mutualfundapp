import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutualfundapp/models/home_screen_model.dart';
import 'package:mutualfundapp/repositories/network_controller.dart';

class MutualFundController extends GetxController {
  var mutualFunds = <MutualFund>[].obs;
  var allMutualFunds = <MutualFund>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadMutualFunds();
  }

  void loadMutualFunds() async {
    if (storage.hasData('mutualFunds')) {
      // Parse the stored JSON data into a list of MutualFund objects
      allMutualFunds.value = (storage.read('mutualFunds') as List)
          .map((json) => MutualFund.fromJson(json))
          .toList();
      mutualFunds.value = allMutualFunds;
    } else {
      try {
        var fetchedFunds = await MutualFundService.fetchMutualFunds();
        allMutualFunds.value = fetchedFunds;
        mutualFunds.value = allMutualFunds;
        // Store the data locally as JSON
        storage.write(
            'mutualFunds', fetchedFunds.map((fund) => fund.toJson()).toList());
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch mutual funds');
      }
    }
  }

  void filterMutualFunds(String query) {
    if (query.isEmpty) {
      mutualFunds.value = allMutualFunds;
    } else {
      var filteredFunds = allMutualFunds
          .where((fund) =>
              fund.schemeName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      mutualFunds.value = filteredFunds;
    }
  }
}
