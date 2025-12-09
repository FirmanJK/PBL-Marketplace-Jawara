import 'package:jawara/models/house.dart';
<<<<<<< HEAD
=======
import 'package:jawara/models/resident.dart';
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';

class HouseService {
  static const String endpoint = '/houses';
  static final AuthService _auth = AuthService();

  static Future<List<House>> getHouses({int skip = 0, int limit = 100}) async {
    try {
      final token = _auth.accessToken;
      final response = await ApiService.get(
        endpoint,
        queryParams: {'skip': skip.toString(), 'limit': limit.toString()},
        token: token,
      );
      final List<dynamic> data = response is List ? response : response['data'] ?? [];
      return data.map((e) => House.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load houses: $e');
    }
  }

  static Future<House> getHouseById(int id) async {
    try {
      final token = _auth.accessToken;
      final response = await ApiService.get('$endpoint/$id', token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return House.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load house: $e');
    }
  }

  static Future<House> createHouse(Map<String, dynamic> body) async {
    try {
      final token = _auth.accessToken;
      final response = await ApiService.post(endpoint, body: body, token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return House.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create house: $e');
    }
  }

  static Future<House> updateHouse(int id, Map<String, dynamic> body) async {
    try {
      final token = _auth.accessToken;
      final response = await ApiService.put('$endpoint/$id', body: body, token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return House.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update house: $e');
    }
  }

  static Future<void> deleteHouse(int id) async {
    try {
      final token = _auth.accessToken;
      await ApiService.delete('$endpoint/$id', token: token);
    } catch (e) {
      throw Exception('Failed to delete house: $e');
    }
  }
<<<<<<< HEAD
=======

  /// Assign an existing resident to an existing house using server-side assign endpoint
  static Future<Resident> assignHouse(int houseId, int residentId) async {
    try {
      final token = _auth.accessToken;
      final response = await ApiService.post('$endpoint/$houseId/assign/$residentId', token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return Resident.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to assign resident to house: $e');
    }
  }
>>>>>>> 34f68be6733b1a2592575648b5711e4ea961457a
}
