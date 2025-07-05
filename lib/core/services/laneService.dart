import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lane_model.dart';

class LaneService {
  static final _supabase = Supabase.instance.client;

  static Future<bool> tambahLane(LaneModel model) async {
    try {
      final res = await _supabase.from('lane_lapangan').insert(model.toJson()).select().single();

      if (res == null || res['id_lane'] == null) {
        print("Insert gagal: response kosong");
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

static Future<bool> tambahMultipleLanes(List<LaneModel> lanes) async {
  try {
    final List<Map<String, dynamic>> laneData = lanes.map((lane) => lane.toJson()).toList();
    
    await _supabase
        .from('lane_lapangan')
        .insert(laneData);
    
    return true;
  } catch (e) {
    throw Exception('Gagal menyimpan lanes: ${e.toString()}');
  }
}


  static Future<List<LaneModel>> ambilLaneByLapangan(String idLapangan) async {
  try {
    final res = await _supabase
        .from('lane_lapangan')
        .select()
        .eq('id_lapangan', idLapangan)
        .order('created_at', ascending: true); 

    return (res as List).map((e) => LaneModel.fromJson(e)).toList();
  } catch (e) {
    throw Exception('Gagal mengambil data lane: ${e.toString()}');
  }
}

  static Future<List<Map<String, dynamic>>> ambilLaneWithJenisOlahraga(String idLapangan) async {
    try {
      final res = await _supabase
          .from('lane_lapangan')
          .select('''
            *,
            jenis_olahraga!inner(
              id_jenis_olahraga,
              nama_jenis,
              deskripsi
            )
          ''')
          .eq('id_lapangan', idLapangan)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      throw Exception('Gagal mengambil data lane dengan jenis olahraga: ${e.toString()}');
    }
  }

  static Future<void> hapusLane(String id) async {
    try {
      await _supabase.from('lane_lapangan').delete().eq('id_lane', id);
    } catch (e) {
      throw Exception('Gagal menghapus lane: ${e.toString()}');
    }
  }

  static Future<void> updateLane(String id, LaneModel model) async {
    try {
      await _supabase
          .from('lane_lapangan')
          .update(model.toJson())
          .eq('id_lane', id);
    } catch (e) {
      throw Exception('Gagal memperbarui lane: ${e.toString()}');
    }
  }

  static Future<void> hapusLaneByLapangan(String idLapangan) async {
    try {
      await _supabase
          .from('lane_lapangan')
          .delete()
          .eq('id_lapangan', idLapangan);
    } catch (e) {
      throw Exception('Gagal menghapus lanes lapangan: ${e.toString()}');
    }
  }

  static Future<bool> validateLaneData(LaneModel model) async {
    try {
      final lapanganExists = await _supabase
          .from('lapangan')
          .select('id_lapangan')
          .eq('id_lapangan', model.idLapangan)
          .maybeSingle();

      if (lapanganExists == null) {
        print('Lapangan dengan ID ${model.idLapangan} tidak ditemukan');
        return false;
      }
      final jenisOlahragaExists = await _supabase
          .from('jenis_olahraga')
          .select('id_jenis_olahraga')
          .eq('id_jenis_olahraga', model.idOlahraga)
          .maybeSingle();

      if (jenisOlahragaExists == null) {
        print('Jenis olahraga dengan ID ${model.idOlahraga} tidak ditemukan');
        return false;
      }

      final duplicateName = await _supabase
          .from('lane_lapangan')
          .select('id_lane')
          .eq('id_lapangan', model.idLapangan)
          .eq('nama_lane', model.namaLane)
          .maybeSingle();

      if (duplicateName != null) {
        print('Lane dengan nama ${model.namaLane} sudah ada di lapangan ini');
        return false;
      }

      return true;
    } catch (e) {
      print('Error validating lane data: ${e.toString()}');
      return false;
    }
  }
}
