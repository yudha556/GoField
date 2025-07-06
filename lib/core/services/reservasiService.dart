import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/reservasi_models.dart';

class ReservasiService {
  final supabase = Supabase.instance.client;

  Future<String?> buatReservasi(ReservasiModel reservasi) async {
    final response = await supabase
        .from('reservasi')
        .insert(reservasi.toJson())
        .select()
        .single();

    if (response == null || response['id_reservasi'] == null) {
      throw Exception('Gagal membuat reservasi');
    }
    return response['id_reservasi'] as String;
  }

  Future<List<Map<String, dynamic>>> getRiwayatReservasi(String userId) async {
    final response = await supabase
        .from('reservasi')
        .select('*, lapangan(*), lane_lapangan(*), pembayaran(*)')
        .eq('id_pengguna', userId)
        .order('tanggal_dibuat', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
