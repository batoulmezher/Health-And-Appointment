import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';

class WalletService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');

  Future<int?> getBalance() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/wallet/balance',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print("📥 Balance response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          final data = json['data'];
          final balance = data['balance_points'] as int?;
          return balance ?? 0;
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Get balance error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Get balance error: $e");
      return null;
    }
  }

  Future<int?> rechargeWallet(int points) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.post(
        '/api/v1/wallet/recharge',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          'points_amount': points,
        },
      );

      print("📥 Recharge response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          final data = json['data'];
          final newBalance = data['balance_points'] as int?;
          return newBalance ?? 0;
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Recharge error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Recharge error: $e");
      return null;
    }
  }
}