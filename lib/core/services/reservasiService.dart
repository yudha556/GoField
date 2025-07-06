import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/reservasi_models.dart';

class ReservasiService {
  final supabase = Supabase.instance.client;

  Future<void> buatReservasi(ReservasiModel reservasi) async {
    final response = await supabase.from('reservasi').insert(reservasi.toJson());

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}
