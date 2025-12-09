import 'package:jawara/models/resident.dart';
import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';

class ResidentsService {
  static const String endpoint = '/residents';
  static const String dataEndpoint = '/residents/data';
  static final AuthService _authService = AuthService();

  /// Get all residents with pagination
  static Future<List<Resident>> getResidents({
    int skip = 0,
    int limit = 100,
    String? query,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (query != null) 'q': query,
      };

      final token = _authService.accessToken;
      final response = await ApiService.get(
        dataEndpoint,
        queryParams: queryParams,
        token: token,
      );

      final List<dynamic> data = response is List
          ? response
          : response['data'] ?? [];
      return data
          .map((json) => Resident.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load residents: $e');
    }
  }

  /// Get resident by ID
  static Future<Resident> getResidentById(int id) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.get('$endpoint/$id', token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return Resident.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load resident: $e');
    }
  }

  /// Create new resident
  static Future<Resident> createResident(Map<String, dynamic> data) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.post(
        endpoint,
        body: data,
        token: token,
      );
      final resData = response is Map ? response : response['data'] ?? response;
      return Resident.fromJson(resData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create resident: $e');
    }
  }

  /// Update resident
  static Future<Resident> updateResident(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.put(
        '$endpoint/$id',
        body: data,
        token: token,
      );
      final resData = response is Map ? response : response['data'] ?? response;
      return Resident.fromJson(resData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update resident: $e');
    }
  }

  /// Delete resident
  static Future<void> deleteResident(int id) async {
    try {
      final token = _authService.accessToken;
      await ApiService.delete('$endpoint/$id', token: token);
    } catch (e) {
      throw Exception('Failed to delete resident: $e');
    }
  }

  /// Get all families
  static Future<List<Map<String, dynamic>>> getFamilies() async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.get('/families', token: token);

      final List<dynamic> data = response is List
          ? response
          : response['data'] ?? [];
      return data
          .map((json) => Map<String, dynamic>.from(json as Map))
          .toList();
    } catch (e) {
      throw Exception('Failed to load families: $e');
    }
  }
}
