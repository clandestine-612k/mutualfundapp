import 'package:dio/dio.dart';
import 'package:mutualfundapp/models/home_screen_model.dart';

class MutualFundService {
  static const String baseUrl = 'https://api.mfapi.in/mf';

  static Future<List<MutualFund>> fetchMutualFunds() async {
    try {
      Response response = await Dio().get(baseUrl);
      return (response.data as List)
          .map((json) => MutualFund.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch mutual funds');
    }
  }
}
