import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/pembayaran_model.dart';

class PembayaranService {
  final supabase = Supabase.instance.client;

  Future<void> buatPembayaran(PembayaranModel pembayaran) async {
    await supabase.from('pembayaran').insert(pembayaran.toJson());
  }
}