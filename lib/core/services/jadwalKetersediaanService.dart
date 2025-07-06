import 'package:supabase_flutter/supabase_flutter.dart';

class JadwalService {
  final supabase = Supabase.instance.client;

  // Insert jadwal baru
  Future<Map<String, dynamic>?> buatJadwal({
    required String idLane,
    required DateTime tanggal,
    required String waktuMulai,
    required String waktuSelesai,
    String status = 'dipesan',
  }) async {
    final response = await supabase
        .from('jadwal_ketersediaan')
        .insert({
          'id_lane': idLane,
          'tanggal_tersedia': tanggal.toIso8601String().substring(0, 10),
          'waktu_mulai': waktuMulai,
          'waktu_selesai': waktuSelesai,
          'status_ketersediaan': status,
        })
        .select()
        .single();
    return response;
  }

  // Query jadwal untuk lane & tanggal tertentu
  Future<List<Map<String, dynamic>>> getJadwalByLaneAndTanggal({
    required String idLane,
    required DateTime tanggal,
  }) async {
    final response = await supabase
        .from('jadwal_ketersediaan')
        .select()
        .eq('id_lane', idLane)
        .eq('tanggal_tersedia', tanggal.toIso8601String().substring(0, 10));
    return List<Map<String, dynamic>>.from(response);
  }
}