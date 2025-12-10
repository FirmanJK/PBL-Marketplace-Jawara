import 'package:jawara/models/resident_approval.dart';
import 'package:jawara/services/api_service.dart';
import 'package:jawara/services/auth_service.dart';

class ResidentApprovalService {
  static const String endpoint = '/resident-approvals';
  static final AuthService _authService = AuthService();

  /// Get list of approvals with optional status filter
  /// Default: status = "pending_approval" (untuk list pending yang diapprove RT/RW)
  static Future<List<ResidentApproval>> getApprovals({
    int skip = 0,
    int limit = 100,
    String? status,
  }) async {
    try {
      final queryParams = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };

      final token = _authService.accessToken;
      final response = await ApiService.get(
        endpoint,
        queryParams: queryParams,
        token: token,
      );

      // Handle different response formats
      final List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map && response['data'] != null) {
        data = response['data'] as List<dynamic>;
      } else {
        data = [];
      }

      return data
          .map(
            (json) => ResidentApproval.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat data pengajuan: $e');
    }
  }

  /// Get pending approvals specifically (for RT/RW approval page)
  static Future<List<ResidentApproval>> getPendingApprovals({
    int skip = 0,
    int limit = 100,
  }) async {
    return getApprovals(skip: skip, limit: limit, status: 'pending_approval');
  }

  /// Get single approval by ID
  static Future<ResidentApproval> getApprovalById(int id) async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.get('$endpoint/$id', token: token);

      final data = response is Map ? response : response['data'] ?? response;
      return ResidentApproval.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Gagal memuat detail pengajuan: $e');
    }
  }

  /// Approve resident registration
  /// - familyId: Keluarga yang akan di-assign ke resident
  /// - note: Catatan approval (opsional)
  static Future<ResidentApproval> approveResident(
    int approvalId, {
    required int familyId,
    String? note,
  }) async {
    try {
      final token = _authService.accessToken;
      final body = {
        'status': 'approved',
        'family_id': familyId,
        if (note != null && note.isNotEmpty) 'note': note,
      };

      final response = await ApiService.put(
        '$endpoint/$approvalId',
        body: body,
        token: token,
      );

      final data = response is Map ? response : response['data'] ?? response;
      return ResidentApproval.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Gagal menerima pengajuan: $e');
    }
  }

  /// Reject resident registration
  /// Backend akan DELETE resident + user + approval (clean slate)
  /// Ini memungkinkan warga untuk re-register dengan NIK yang sama
  static Future<void> rejectResident(
    int approvalId, {
    required String note,
  }) async {
    try {
      final token = _authService.accessToken;
      final body = {'status': 'rejected', 'note': note};

      await ApiService.put('$endpoint/$approvalId', body: body, token: token);
    } catch (e) {
      throw Exception('Gagal menolak pengajuan: $e');
    }
  }

  /// Get approval statistics (pending, approved, rejected count)
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final token = _authService.accessToken;
      final response = await ApiService.get(
        '$endpoint/statistics',
        token: token,
      );

      return response is Map ? response : response['data'] ?? {};
    } catch (e) {
      throw Exception('Gagal memuat statistik: $e');
    }
  }
}
