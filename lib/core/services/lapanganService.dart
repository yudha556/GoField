import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lapangan_model.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';

class LapanganService {
  static final _supabase = Supabase.instance.client;

  static Future<String> tambahLapangan(LapanganModel model) async {
    try {
      final res = await _supabase
          .from('lapangan')
          .insert(model.toJson())
          .select('id_lapangan')
          .single();

      return res['id_lapangan'];
    } catch (e) {
      throw Exception('Gagal menyimpan lapangan: ${e.toString()}');
    }
  }

  static Future<List<LapanganModel>> ambilLapanganByPemilik(
    String idPemilik,
  ) async {
    try {
      final res = await _supabase
          .from('lapangan')
          .select()
          .eq('id_pemilik', idPemilik)
          .order('created_at', ascending: false);

      return (res as List).map((e) => LapanganModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data lapangan: ${e.toString()}');
    }
  }

  static Future<void> hapusLapangan(String id) async {
    try {
      await _supabase.from('lapangan').delete().eq('id_lapangan', id);
    } catch (e) {
      throw Exception('Gagal menghapus lapangan: ${e.toString()}');
    }
  }

  static Future<LapanganModel?> ambilLapanganById(String id) async {
    try {
      final res = await _supabase
          .from('lapangan')
          .select()
          .eq('id_lapangan', id)
          .maybeSingle();

      return res != null ? LapanganModel.fromJson(res) : null;
    } catch (e) {
      throw Exception('Gagal mengambil detail lapangan: ${e.toString()}');
    }
  }

  static Future<void> updateLapangan(String id, LapanganModel model) async {
    try {
      await _supabase
          .from('lapangan')
          .update(model.toJson())
          .eq('id_lapangan', id);
    } catch (e) {
      throw Exception('Gagal memperbarui lapangan: ${e.toString()}');
    }
  }

  static Future<LapanganDetailModel?> getDetailLapangan(
    String idLapangan,
  ) async {
    try {
      print('Fetching detail lapangan: $idLapangan');

      final response = await _supabase
          .from('lapangan')
          .select('''
            id_lapangan,
            id_pemilik,
            nama_lapangan,
            deskripsi_lapangan,
            alamat_lapangan,
            kapasitas_pemain,
            status_lapangan,
            kecamatan,
            kabupaten,
            provinsi,
            latitude,
            longitude,
            fasilitas,
            created_at,
            updated_at,
            lanes:lane_lapangan(
              id_lane,
              nama_lane,
              deskripsi,
              kapasitas_pemain,
              harga_per_jam,
              aktif,
              created_at,
              updated_at,
              jenis_olahraga:jenis_olahraga(nama_jenis)
            )
          ''')
          .eq('id_lapangan', idLapangan)
          .single();

      return LapanganDetailModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil detail lapangan: ${e.toString()}');
    }
  }

  static Future<bool> updateStatusLapangan(
    String idLapangan,
    String status,
  ) async {
    try {
      await _supabase
          .from('lapangan')
          .update({
            'status_lapangan': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id_lapangan', idLapangan);

      return true;
    } catch (e) {
      throw Exception('Gagal mengupdate status lapangan: ${e.toString()}');
    }
  }

  static Future<bool> updateLapanganData(
    String idLapangan,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('lapangan')
          .update(data)
          .eq('id_lapangan', idLapangan);

      return true;
    } catch (e) {
      throw Exception('Gagal mengupdate lapangan: ${e.toString()}');
    }
  }

  static Future<bool> deleteLapangan(String idLapangan) async {
    try {
      print('Deleting lapangan: $idLapangan');
      await _supabase
          .from('lane_lapangan')
          .delete()
          .eq('id_lapangan', idLapangan);

      await _supabase.from('lapangan').delete().eq('id_lapangan', idLapangan);

      return true;
    } catch (e) {
      throw Exception('Gagal menghapus lapangan: ${e.toString()}');
    }
  }

  static Future<bool> updateStatusLane(String idLane, bool aktif) async {
    try {
      print('Updating lane status: $idLane to $aktif');
      await _supabase
          .from('lane_lapangan')
          .update({
            'aktif': aktif,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id_lane', idLane);

      return true;
    } catch (e) {
      throw Exception('Gagal mengupdate status lane: ${e.toString()}');
    }
  }

  static Future<bool> deleteLane(String idLane) async {
    try {
      print('Deleting lane: $idLane');
      await _supabase.from('lane_lapangan').delete().eq('id_lane', idLane);

      return true;
    } catch (e) {
      throw Exception('Gagal menghapus lane: ${e.toString()}');
    }
  }

  static Future<List<LapanganModel>> ambilSemuaLapangan({
    String? jenisOlahragaId,
  }) async {
    try {
      final response = await _supabase
          .from('lapangan')
          .select()
          .eq('status_lapangan', 'buka')
          .order('created_at', ascending: false);

      List<LapanganModel> lapanganList = (response as List)
          .map((e) => LapanganModel.fromJson(e))
          .toList();

      if (jenisOlahragaId != null) {
        List<LapanganModel> filteredLapangan = [];

        for (var lapangan in lapanganList) {
          if (lapangan.id != null) {
            final lanesResponse = await _supabase
                .from('lane_lapangan')
                .select('id_lane')
                .eq('id_lapangan', lapangan.id!)
                .eq('id_jenis_olahraga', jenisOlahragaId)
                .eq('aktif', true);

            if (lanesResponse.isNotEmpty) {
              filteredLapangan.add(lapangan);
            }
          }
        }

        return filteredLapangan;
      }

      return lapanganList;
    } catch (e) {
      throw Exception('Gagal mengambil data lapangan: ${e.toString()}');
    }
  }

  static Future<double?> getLowestPriceByLapangan(String idLapangan) async {
    try {
      final lanesResponse = await _supabase
          .from('lane_lapangan')
          .select('harga_per_jam')
          .eq('id_lapangan', idLapangan)
          .eq('aktif', true)
          .not('harga_per_jam', 'is', null);

      if (lanesResponse.isEmpty) return null;

      double? lowestPrice;
      for (var lane in lanesResponse) {
        final price = lane['harga_per_jam']?.toDouble();
        if (price != null && price > 0) {
          if (lowestPrice == null || price < lowestPrice) {
            lowestPrice = price;
          }
        }
      }

      return lowestPrice;
    } catch (e) {
      return null;
    }
  }

  static Future<List<LapanganModel>> ambilLapanganPopuler({
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('lapangan')
          .select()
          .eq('status_lapangan', 'tersedia')
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((e) => LapanganModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil lapangan populer: ${e.toString()}');
    }
  }

  static Future<List<LapanganModel>> searchLapangan(String query) async {
    try {
      final response = await _supabase
          .from('lapangan')
          .select()
          .eq('status_lapangan', 'tersedia')
          .or(
            'nama_lapangan.ilike.%$query%,kecamatan.ilike.%$query%,kabupaten.ilike.%$query%',
          )
          .order('created_at', ascending: false);

      return (response as List).map((e) => LapanganModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mencari lapangan: ${e.toString()}');
    }
  }

  static Future<List<LapanganModel>> ambilLapanganTerdekat({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      // Untuk sementara, kita ambil semua lapangan yang memiliki koordinat
      final response = await _supabase
          .from('lapangan')
          .select()
          .eq('status_lapangan', 'tersedia')
          .not('latitude', 'is', null)
          .not('longitude', 'is', null)
          .order('created_at', ascending: false);

      return (response as List).map((e) => LapanganModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil lapangan terdekat: ${e.toString()}');
    }
  }

  static Future<int> getLapanganAktif(String userId) async {
    final response = await Supabase.instance.client
        .from('lapangan')
        .select('id_lapangan')
        .eq('id_pemilik', userId)
        .eq('status_lapangan', 'buka');

    return response.length;
  }

  Future<List<Map<String, dynamic>>> getLapanganList(String userId) async {
    return await Supabase.instance.client
        .from('lapangan')
        .select()
        .eq('id_pemilik', userId);
  }

  static Future<int> getTotalLapangan() async {
    final response = await Supabase.instance.client
        .from('lapangan')
        .select('id_lapangan');

    return response.length;
  }

  static Future<int> getTotalLapanganAktif() async {
    final response = await Supabase.instance.client
        .from('lapangan')
        .select('id_lapangan')
        .eq('status_lapangan', 'buka');

    return response.length;
  }
}
