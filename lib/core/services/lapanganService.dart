import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lapangan_model.dart';

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
  

  static Future<List<LapanganModel>> ambilLapanganByPemilik(String idPemilik) async {
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
}
