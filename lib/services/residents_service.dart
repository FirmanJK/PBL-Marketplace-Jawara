import 'package:jawara/models/resident.dart';
import 'package:jawara/services/api_service.dart';

class ResidentsService {
  static const String endpoint = '/residents';

  /// Get all residents with pagination
  static Future<List<Resident>> getResidents({
    int page = 1,
    int limit = 20,
    String? search,
    RegistrationStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (status != null) {
        queryParams['status'] = status.name;
      }

      final response = await ApiService.get(endpoint, queryParams: queryParams);
      
      final List<dynamic> data = response['data'] ?? response;
      return data.map((json) => Resident.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load residents: $e');
    }
  }

  /// Get resident by ID
  static Future<Resident> getResidentById(int id) async {
    try {
      final response = await ApiService.get('$endpoint/$id');
      return Resident.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to load resident: $e');
    }
  }

  /// Create new resident
  static Future<Resident> createResident(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post(endpoint, body: data);
      return Resident.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to create resident: $e');
    }
  }

  /// Update resident
  static Future<Resident> updateResident(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('$endpoint/$id', body: data);
      return Resident.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to update resident: $e');
    }
  }

  /// Delete resident
  static Future<void> deleteResident(int id) async {
    try {
      await ApiService.delete('$endpoint/$id');
    } catch (e) {
      throw Exception('Failed to delete resident: $e');
    }
  }

  /// Update resident status
  static Future<Resident> updateStatus(int id, RegistrationStatus status) async {
    try {
      final response = await ApiService.put(
        '$endpoint/$id/status',
        body: {'status': status.name},
      );
      return Resident.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}
