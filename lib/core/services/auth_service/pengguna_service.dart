import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/pengguna_model.dart';

class PenggunaService {
  static final _supabase = Supabase.instance.client;
  static const String _tableName = 'pengguna';

  // Create pengguna record after auth signup
  static Future<PenggunaModel?> createPengguna({
    required String idPengguna, // UUID from auth.users.id
    required String namaLengkap,
    required String email,
    String? nomorTelepon,
    String? alamat,
    PeranEnum peran = PeranEnum.pengguna,
  }) async {
    try {
      final insertData = {
        'id_pengguna': idPengguna,
        'nama_lengkap': namaLengkap,
        'email': email,
        'nomor_telepon': nomorTelepon,
        'alamat': alamat,
        'peran': peran.value,
        // tanggal_daftar dan aktif akan menggunakan default value dari database
      };

      final response = await _supabase
          .from(_tableName)
          .insert(insertData)
          .select()
          .single();

      return PenggunaModel.fromJson(response);
    } catch (e) {
      print('Error creating pengguna: $e');
      rethrow;
    }
  }

  // Get pengguna by ID
  static Future<PenggunaModel?> getPenggunaById(String idPengguna) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id_pengguna', idPengguna)
          .eq('aktif', true) // Only get active users
          .single();

      return PenggunaModel.fromJson(response);
    } catch (e) {
      print('Error getting pengguna: $e');
      return null;
    }
  }

  // Get pengguna by email
  static Future<PenggunaModel?> getPenggunaByEmail(String email) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('email', email)
          .eq('aktif', true)
          .single();

      return PenggunaModel.fromJson(response);
    } catch (e) {
      print('Error getting pengguna by email: $e');
      return null;
    }
  }

  // Update pengguna
  static Future<PenggunaModel?> updatePengguna({
    required String idPengguna,
    String? namaLengkap,
    String? nomorTelepon,
    String? alamat,
    PeranEnum? peran,
    bool? aktif,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (namaLengkap != null) updateData['nama_lengkap'] = namaLengkap;
      if (nomorTelepon != null) updateData['nomor_telepon'] = nomorTelepon;
      if (alamat != null) updateData['alamat'] = alamat;
      if (peran != null) updateData['peran'] = peran.value;
      if (aktif != null) updateData['aktif'] = aktif;

      final response = await _supabase
          .from(_tableName)
          .update(updateData)
          .eq('id_pengguna', idPengguna)
          .select()
          .single();

      return PenggunaModel.fromJson(response);
    } catch (e) {
      print('Error updating pengguna: $e');
      rethrow;
    }
  }

  // Soft delete pengguna (set aktif = false)
  static Future<bool> deactivatePengguna(String idPengguna) async {
    try {
      await _supabase
          .from(_tableName)
          .update({'aktif': false})
          .eq('id_pengguna', idPengguna);
      
      return true;
    } catch (e) {
      print('Error deactivating pengguna: $e');
      return false;
    }
  }

  // Activate pengguna
  static Future<bool> activatePengguna(String idPengguna) async {
    try {
      await _supabase
          .from(_tableName)
          .update({'aktif': true})
          .eq('id_pengguna', idPengguna);
      
      return true;
    } catch (e) {
      print('Error activating pengguna: $e');
      return false;
    }
  }

  // Hard delete pengguna (will cascade delete auth.users)
  static Future<bool> deletePengguna(String idPengguna) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id_pengguna', idPengguna);
      
      return true;
    } catch (e) {
      print('Error deleting pengguna: $e');
      return false;
    }
  }

  // Get all active pengguna (for admin)
  static Future<List<PenggunaModel>> getAllActivePengguna() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('aktif', true)
          .order('tanggal_daftar', ascending: false);

      return (response as List)
          .map((json) => PenggunaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting all active pengguna: $e');
      return [];
    }
  }

  // Get all pengguna including inactive (for admin)
  static Future<List<PenggunaModel>> getAllPengguna() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('tanggal_daftar', ascending: false);

      return (response as List)
          .map((json) => PenggunaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting all pengguna: $e');
      return [];
    }
  }

  // Get pengguna by role
  static Future<List<PenggunaModel>> getPenggunaByRole(PeranEnum peran, {bool activeOnly = true}) async {
    try {
      var query = _supabase
          .from(_tableName)
          .select()
          .eq('peran', peran.value);

      if (activeOnly) {
        query = query.eq('aktif', true);
      }

      final response = await query.order('tanggal_daftar', ascending: false);

      return (response as List)
          .map((json) => PenggunaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting pengguna by role: $e');
      return [];
    }
  }

  // Search pengguna by name or email
  static Future<List<PenggunaModel>> searchPengguna(String query, {bool activeOnly = true}) async {
    try {
      var supabaseQuery = _supabase
          .from(_tableName)
          .select()
          .or('nama_lengkap.ilike.%$query%,email.ilike.%$query%');

      if (activeOnly) {
        supabaseQuery = supabaseQuery.eq('aktif', true);
      }

      final response = await supabaseQuery.order('tanggal_daftar', ascending: false);

      return (response as List)
          .map((json) => PenggunaModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching pengguna: $e');
      return [];
    }
  }

  // Get pengguna statistics - Fixed version
  static Future<Map<String, int>> getPenggunaStats() async {
    try {
      // Method 1: Menggunakan count() yang lebih sederhana
      final totalCount = await _supabase
          .from(_tableName)
          .select()
          .count();

      final activeCount = await _supabase
          .from(_tableName)
          .select()
          .eq('aktif', true)
          .count();

      final adminCount = await _supabase
          .from(_tableName)
          .select()
          .eq('peran', 'admin')
          .eq('aktif', true)
          .count();

      final pemilikCount = await _supabase
          .from(_tableName)
          .select()
          .eq('peran', 'pemilik')
          .eq('aktif', true)
          .count();

      final penggunaCount = await _supabase
          .from(_tableName)
          .select()
          .eq('peran', 'pengguna')
          .eq('aktif', true)
          .count();

      return {
        'total': totalCount.count,
        'active': activeCount.count,
        'admin': adminCount.count,
        'pemilik': pemilikCount.count,
        'pengguna': penggunaCount.count,
      };
    } catch (e) {
      print('Error getting pengguna stats: $e');
      // Fallback ke method alternative
      return await getPenggunaStatsAlternative();
    }
  }

  // Alternative method for getting stats without using count (if above doesn't work)
  static Future<Map<String, int>> getPenggunaStatsAlternative() async {
    try {
      // Get all pengguna data
      final allPengguna = await getAllPengguna();
      final activePengguna = allPengguna.where((p) => p.aktif).toList();
      
      final adminCount = activePengguna.where((p) => p.peran == PeranEnum.admin).length;
      final pemilikCount = activePengguna.where((p) => p.peran == PeranEnum.pemilik).length;
      final penggunaCount = activePengguna.where((p) => p.peran == PeranEnum.pengguna).length;

      return {
        'total': allPengguna.length,
        'active': activePengguna.length,
        'admin': adminCount,
        'pemilik': pemilikCount,
        'pengguna': penggunaCount,
      };
    } catch (e) {
      print('Error getting pengguna stats alternative: $e');
      return {
        'total': 0,
        'active': 0,
        'admin': 0,
        'pemilik': 0,
        'pengguna': 0,
      };
    }
  }
}
