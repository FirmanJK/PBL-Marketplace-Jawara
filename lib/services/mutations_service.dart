import 'package:jawara/services/api_service.dart';
import 'package:jawara/models/mutations.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/services/families_service.dart';

// simple in-memory cache for family_number by id to avoid repeated requests
final Map<int, String> _familyNumberCache = {};

final _auth = AuthService();

class MutationsService {
  static Future<List<Mutation>> getMutations({int skip = 0, int limit = 100}) async {
    final token = _auth.accessToken;
    final res = await ApiService.get('/family-mutations', queryParams: {'skip': '$skip', 'limit': '$limit'}, token: token);
    if (res == null) return [];
    final List list = res as List;

    // Map entries asynchronously because we may need to fetch family details
    final futures = list.map((e) async {
      final id = e['id'] ?? 0;
      final tanggalRaw = e['created_at']?.toString() ?? '';
      String tanggal = '';
      try {
        final dt = DateTime.tryParse(tanggalRaw);
        if (dt != null) {
          tanggal = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
        } else {
          tanggal = tanggalRaw.split('T').first ?? tanggalRaw;
        }
      } catch (_) {
        tanggal = tanggalRaw;
      }

      int? familyId;
      if (e['family_id'] is int) familyId = e['family_id'] as int;
      else if (e['family_id'] != null) familyId = int.tryParse('${e['family_id']}');

      String keluarga = '-';
      if (e['family_number'] != null && (e['family_number'] as String).isNotEmpty) {
        keluarga = e['family_number'] as String;
      } else if (familyId != null) {
        // try cache first
        keluarga = _familyNumberCache[familyId] ?? '';
        if (keluarga.isEmpty) {
          try {
            final fam = await FamiliesService.getFamilyById(familyId);
            keluarga = fam.familyNumber;
            _familyNumberCache[familyId] = keluarga;
          } catch (_) {
            keluarga = 'Keluarga #$familyId';
          }
        }
      }

      final jenisMutasi = e['mutation_type'] ?? '-';
      final description = e['description'] ?? '';
      // Prefer backend-provided alamat fields, otherwise parse description
      String alamatLama = (e['alamat_lama'] as String?) ?? '-';
      String alamatBaru = (e['alamat_baru'] as String?) ?? '-';
      String alasan = '';
      if ((alamatLama == '-' || alamatBaru == '-') && description != null && description.isNotEmpty) {
        if (description.contains('|')) {
          final parts = description.split('|');
          for (final p in parts) {
            final kv = p.split(':');
            if (kv.length < 2) continue;
            final key = kv[0].trim().toLowerCase();
            final value = kv.sublist(1).join(':').trim();
            if (key == 'alamat_lama' && alamatLama == '-') alamatLama = value;
            else if (key == 'alamat_baru' && alamatBaru == '-') alamatBaru = value;
            else if (key == 'alasan') alasan = value;
          }
        } else {
          alasan = description;
        }
      }

      return Mutation(
        id: id,
        tanggal: tanggal,
        keluarga: keluarga,
        jenisMutasi: jenisMutasi,
        alamatLama: alamatLama,
        alamatBaru: alamatBaru,
        alasan: alasan,
      );
    }).toList();

    return await Future.wait(futures);
  }

  static Future<Mutation> getMutation(int id) async {
    final token = _auth.accessToken;
    final e = await ApiService.get('/family-mutations/$id', token: token);
    final tanggalRaw = e['created_at']?.toString() ?? '';
    String tanggal = '';
    try {
      final dt = DateTime.tryParse(tanggalRaw);
      if (dt != null) {
        tanggal = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      } else {
        tanggal = tanggalRaw.split('T').first ?? tanggalRaw;
      }
    } catch (_) {
      tanggal = tanggalRaw;
    }

    String keluarga = (e['family_number'] as String?) ?? '';
    if (keluarga.isEmpty) {
      final familyId = e['family_id'] is int ? e['family_id'] as int : int.tryParse('${e['family_id']}');
      if (familyId != null) {
        keluarga = _familyNumberCache[familyId] ?? '';
        if (keluarga.isEmpty) {
          try {
            final fam = await FamiliesService.getFamilyById(familyId);
            keluarga = fam.familyNumber;
            _familyNumberCache[familyId] = keluarga;
          } catch (_) {
            keluarga = 'Keluarga #$familyId';
          }
        }
      } else {
        keluarga = '-';
      }
    }
    return Mutation(
      id: e['id'] ?? 0,
      tanggal: tanggal,
      keluarga: keluarga,
      jenisMutasi: e['mutation_type'] ?? '-',
      alamatLama: e['alamat_lama'] ?? '-',
      alamatBaru: e['alamat_baru'] ?? '-',
      alasan: e['description'] ?? '',
    );
  }

  static Future<void> createMutation(Map<String, dynamic> payload) async {
    final token = _auth.accessToken;
    if (token == null) throw Exception('Not authenticated');
    await ApiService.post('/family-mutations', body: payload, token: token);
  }

  static Future<void> deleteMutation(int id) async {
    final token = _auth.accessToken;
    if (token == null) throw Exception('Not authenticated');
    await ApiService.delete('/family-mutations/$id', token: token);
  }
}
