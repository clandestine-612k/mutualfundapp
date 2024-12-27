import 'package:dio/dio.dart';

class NetworkRequester {
  final Dio _dio = Dio();

  Future<Response> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response;
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }
}
