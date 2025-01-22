import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchData({required int page, required int results}) async {
    try {
      final response = await _dio.get(
        'https://randomuser.me/api/?page=1&results=10');
      return response.data['results'];
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
