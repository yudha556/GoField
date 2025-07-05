import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/jenisOlahraga_model.dart';

class JenisOlahragaService {
  static final _supabase = Supabase.instance.client;

  static Future<List<JenisOlahragaModel>> ambilSemuaJenisOlahraga() async {
    try {
      final res = await _supabase
          .from('jenis_olahraga')
          .select()
          .eq('aktif', true)
          .order('nama_jenis');

      return (res as List).map((e) => JenisOlahragaModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data jenis olahraga: ${e.toString()}');
    }
  }

  static Future<JenisOlahragaModel?> ambilJenisOlahragaByNama(String nama) async {
    try {
      final res = await _supabase
          .from('jenis_olahraga')
          .select()
          .eq('nama_jenis', nama)
          .eq('aktif', true)
          .maybeSingle();

      return res != null ? JenisOlahragaModel.fromJson(res) : null;
    } catch (e) {
      throw Exception('Gagal mencari jenis olahraga: ${e.toString()}');
    }
  }

  static Future<JenisOlahragaModel?> ambilJenisOlahragaById(String id) async {
    try {
      final res = await _supabase
          .from('jenis_olahraga')
          .select()
          .eq('id_jenis_olahraga', id)
          .eq('aktif', true)
          .maybeSingle();

      return res != null ? JenisOlahragaModel.fromJson(res) : null;
    } catch (e) {
      throw Exception('Gagal mengambil detail jenis olahraga: ${e.toString()}');
    }
  }

  static Future<void> tambahJenisOlahraga(JenisOlahragaModel model) async {
    try {
      await _supabase.from('jenis_olahraga').insert(model.toJson());
    } catch (e) {
      throw Exception('Gagal menambah jenis olahraga: ${e.toString()}');
    }
  }

  static Future<void> updateJenisOlahraga(String id, JenisOlahragaModel model) async {
    try {
      await _supabase
          .from('jenis_olahraga')
          .update(model.toJson())
          .eq('id_jenis_olahraga', id);
    } catch (e) {
      throw Exception('Gagal memperbarui jenis olahraga: ${e.toString()}');
    }
  }
}
