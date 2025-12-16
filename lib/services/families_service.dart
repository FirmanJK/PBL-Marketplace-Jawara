import 'package:jawara/models/family.dart';
import 'package:jawara/models/resident.dart';
import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';
// residents_service no longer required for families; server provides head_resident

class FamiliesService {
  static const String endpoint = '/families';
  static const String dataEndpoint = '/families';
  static final AuthService _authService = AuthService();

  static Future<List<Family>> getFamilies({int skip = 0, int limit = 100}) async {
    try {
      final queryParams = <String, dynamic>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      final token = _authService.accessToken;
      final response = await ApiService.get(
        dataEndpoint,
        queryParams: queryParams,
        token: token,
      );

      // Map server response directly to Family objects. Server now includes
      // `head_resident` object; Family.fromJson will prefer that. We keep no
      // longer a client-side batch fetch of residents.
      final List<dynamic> data = response is List ? response : response['data'] ?? [];
      final families = data.map((json) => Family.fromJson(json as Map<String, dynamic>)).toList();
      return families;
    } catch (e) {
      throw Exception('Failed to load families: $e');
    }
  }

  /// Add (or transfer) an existing resident to a family
  static Future<Resident> addResidentToFamily(int familyId, int residentId) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.post('$endpoint/$familyId/members/$residentId', token: token);
      final resData = response is Map ? response : response['data'] ?? response;
      return Resident.fromJson(resData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add resident to family: $e');
    }
  }

  static Future<Family> getFamilyById(int id) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.get('$endpoint/$id', token: token);
      final data = response is Map ? response : response['data'] ?? response;
      return Family.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load family: $e');
    }
  }

  /// Get single family along with member list
  static Future<Map<String, dynamic>> getFamilyWithMembers(int id) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.get('$endpoint/$id', token: token);
      final data = response is Map ? response : response['data'] ?? response;

      final family = Family.fromJson(data as Map<String, dynamic>);

      final List<Resident> members = [];
      if (data is Map && data['residents'] is List) {
        final list = data['residents'] as List<dynamic>;
        for (final item in list) {
          try {
            members.add(Resident.fromJson(item as Map<String, dynamic>));
          } catch (_) {}
        }
      }

      return {'family': family, 'residents': members};
    } catch (e) {
      throw Exception('Failed to load family with members: $e');
    }
  }

  static Future<Family> createFamily(Map<String, dynamic> data) async {
    try {
      final token = _authService.accessToken;
      // If no token is available (unauthenticated), use the public endpoint
      // we added on the server to allow creating families for demos/tests.
      final createEndpoint = token == null ? '$endpoint/public' : endpoint;
      final response = await ApiService.post(createEndpoint, body: data, token: token);
      final resData = response is Map ? response : response['data'] ?? response;
      return Family.fromJson(resData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create family: $e');
    }
  }

  static Future<Family> updateFamily(int id, Map<String, dynamic> data) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.put('$endpoint/$id', body: data, token: token);
      final resData = response is Map ? response : response['data'] ?? response;
      return Family.fromJson(resData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update family: $e');
    }
  }

  static Future<void> deleteFamily(int id) async {
    try {
      final token = _authService.accessToken;
      await ApiService.delete('$endpoint/$id', token: token);
    } catch (e) {
      throw Exception('Failed to delete family: $e');
    }
  }

  /// Remove an existing resident from the family (unassign resident.family_id)
  static Future<void> removeResidentFromFamily(int familyId, int residentId) async {
    try {
      final token = _authService.accessToken;
      // Server returns 204 No Content on success; we only need to ensure the request completes.
      await ApiService.delete('$endpoint/$familyId/members/$residentId', token: token);
      return;
    } catch (e) {
      throw Exception('Failed to remove resident from family: $e');
    }
  }
}
