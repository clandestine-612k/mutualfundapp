import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutualfundapp/models/home_screen_model.dart';
import 'package:mutualfundapp/repositories/network_controller.dart';

class MutualFundController extends GetxController {
  RxList<MutualFund> mutualFunds = <MutualFund>[].obs;
  RxList<MutualFund> allMutualFunds = <MutualFund>[].obs;
  RxBool loading = false.obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadMutualFunds();
  }

  void loadMutualFunds() async {
    loading.value = true; //loading started
    if (storage.hasData('mutualFunds')) {
      // Parse the stored JSON data into a list of MutualFund objects
      allMutualFunds.value = (storage.read('mutualFunds') as List)
          .map((json) => MutualFund.fromJson(json))
          .toList();
      mutualFunds.value = allMutualFunds;
    } else {
      try {
        List<MutualFund> fetchedFunds =
            await MutualFundService.fetchMutualFunds();
        allMutualFunds.value = fetchedFunds;
        mutualFunds.value = allMutualFunds;
        // Store the data locally as JSON
        storage.write(
            'mutualFunds', fetchedFunds.map((fund) => fund.toJson()).toList());
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch mutual funds');
      }
    }
    loading.value = false; // Stop loading
  }

  void filterMutualFunds(String query) {
    if (query.isEmpty) {
      mutualFunds.value = allMutualFunds;
    } else if (query.isNum) {
      List<MutualFund> filteredFunds = allMutualFunds
          .where((fund) => fund.schemeCode.toString().contains(query))
          .toList();
      mutualFunds.value = filteredFunds;
    } else {
      List<MutualFund> filteredFunds = allMutualFunds
          .where((fund) =>
              fund.schemeName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      mutualFunds.value = filteredFunds;
    }
  }
}
