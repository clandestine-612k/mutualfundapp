import 'package:dio/dio.dart';
import 'package:mutualfundapp/data/models/home-screen-model.dart';
import 'package:mutualfundapp/data/models/mutual-fund-model.dart';
import 'package:mutualfundapp/utils/network-requester.dart';

const String baseUrl = 'https://api.mfapi.in/mf/';
final NetworkRequester _netreq = NetworkRequester();

class MutualFundService {
  Future<List<MutualFund>> fetchMutualFunds() async {
    try {
      Response response = await _netreq.get(baseUrl);
      return (response.data as List)
          .map((json) => MutualFund.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch mutual funds');
    }
  }
}

class MutualFundService2 {
  //static const String _baseUrl = 'https://api.mfapi.in/mf/';

  Future<MutualFund2> fetchHistoricalData(int schemeCode) async {
    final url = '$baseUrl$schemeCode'; // Adjust the endpoint as needed

    try {
      final response = await _netreq.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final mutualFund = MutualFund2.fromJson(jsonResponse);

        return mutualFund;
      } else if (response.statusCode != 200) {
        return MutualFund2.fromJson({});
      } else {
        throw Exception(
            'Failed to load Mutual Fund data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Mutual Fund data: $e');
    }
  }
}
