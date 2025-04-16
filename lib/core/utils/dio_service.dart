import 'package:dio/dio.dart';

class DioService {
  late Dio _dio;

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com/', // Ganti dengan base URL API Anda
        connectTimeout: Duration(seconds: 5000), // Waktu timeout koneksi
        receiveTimeout: Duration(seconds: 3000), // Waktu timeout menerima data
      ),
    );
  }

  Dio get dio => _dio;

  // Fungsi untuk melakukan GET request
  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.response?.data}');
    }
  }

  // Fungsi untuk melakukan POST request
  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to send data: ${e.response?.data}');
    }
  }
}
