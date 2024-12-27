import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutualfundapp/data/models/mutual-fund-model.dart';
import 'package:mutualfundapp/data/repositories/network_controller.dart';

class MutualFundController2 extends GetxController {
  final MutualFundService2 _service = MutualFundService2();
  final GetStorage _storage = GetStorage(); // Instance of GetStorage

  RxBool isLoading = false.obs;
  Rx<MutualFund2?> navData =
      Rx<MutualFund2?>(null); // To hold the entire MutualFund2 object
  RxString errorMessage = ''.obs;
  RxInt selectedYears = 1.obs;

  Future<void> fetchHistoricalData(int schemeCode) async {
    isLoading.value = true;
    errorMessage.value = '';
    navData.value = null; // Reset data before fetching

    try {
      final mutualFund = await _service.fetchHistoricalData(schemeCode);
      navData.value = mutualFund; // Assign the fetched data

      // Save data to GetStorage
      _storage.write('mutualFund_$schemeCode', mutualFund.toJson());
    } catch (e) {
      errorMessage.value = e.toString(); // Capture error message
    } finally {
      isLoading.value = false;
    }
  }

  void loadDataFromStorage(int schemeCode) {
    final storedData =
        _storage.read<Map<String, dynamic>>('mutualFund_$schemeCode');
    if (storedData != null) {
      navData.value = MutualFund2.fromJson(storedData);
    }
  }
}
