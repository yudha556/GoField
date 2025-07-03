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

    print("Insert lane berhasil: ${res['id_lane']}");
    return true;
  } catch (e) {
    print('Gagal menambah lane: ${e.toString()}');
    return false;
  }
}


  static Future<bool> tambahMultipleLanes(List<LaneModel> lanes) async {
  if (lanes.isEmpty) return false;

  try {
    final lanesData = lanes.map((lane) => lane.toJson()).toList();
    final res = await _supabase.from('lane_lapangan').insert(lanesData).select();

    if (res == null || (res is List && res.isEmpty)) {
      print("Insert multiple lane gagal: kosong");
      return false;
    }

    print("Berhasil insert multiple lane: ${res.length} data");
    return true;
  } catch (e) {
    print('Gagal menambah multiple lanes: ${e.toString()}');
    return false;
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
}

