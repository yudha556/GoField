import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/lapangan_model.dart';
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
          .order(
            'created_at',
            ascending: false,
          );

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

  static Future<LapanganDetailModel?> getDetailLapangan(String idLapangan) async {
    try {
      print('Fetching detail lapangan: $idLapangan');

      final response = await _supabase
          .from('lapangan')
          .select('''
            *,
            lanes:lane_lapangan(
              *,
              jenis_olahraga:jenis_olahraga(nama_jenis)
            )
          ''')
          .eq('id_lapangan', idLapangan)
          .single();

      print('Detail lapangan response: $response');

      if (response['lanes'] != null) {
        for (var lane in response['lanes']) {
          if (lane['jenis_olahraga'] != null) {
            lane['jenis_olahraga_nama'] = lane['jenis_olahraga']['nama_jenis'];
          }
        }
      }

      return LapanganDetailModel.fromJson(response);
    } catch (e) {
      print('Error fetching detail lapangan: $e');
      throw Exception('Gagal mengambil detail lapangan: ${e.toString()}');
    }
  }

  static Future<bool> updateStatusLapangan(String idLapangan, String status) async {
    try {
      print('Updating lapangan status: $idLapangan to $status');

      await _supabase
          .from('lapangan')
          .update({
            'status_lapangan': status, 
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id_lapangan', idLapangan);

      print('Lapangan status updated successfully');
      return true;
    } catch (e) {
      print('Error updating lapangan status: $e');
      throw Exception('Gagal mengupdate status lapangan: ${e.toString()}');
    }
  }

  static Future<bool> updateLapanganData(String idLapangan, Map<String, dynamic> data) async {
    try {
      print('Updating lapangan: $idLapangan with data: $data');

      data['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('lapangan')
          .update(data)
          .eq('id_lapangan', idLapangan);

      print('Lapangan updated successfully');
      return true;
    } catch (e) {
      print('Error updating lapangan: $e');
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

      await _supabase
          .from('lapangan')
          .delete()
          .eq('id_lapangan', idLapangan);

      print('Lapangan deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting lapangan: $e');
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

      print('Lane status updated successfully');
      return true;
    } catch (e) {
      print('Error updating lane status: $e');
      throw Exception('Gagal mengupdate status lane: ${e.toString()}');
    }
  }

  static Future<bool> deleteLane(String idLane) async {
    try {
      print('Deleting lane: $idLane');
      await _supabase
          .from('lane_lapangan')
          .delete()
          .eq('id_lane', idLane);

      print('Lane deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting lane: $e');
      throw Exception('Gagal menghapus lane: ${e.toString()}');
    }
  }
}
