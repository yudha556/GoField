import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/permintaan_model.dart';
import 'dart:async';

class PermintaanService {
  static final supabase = Supabase.instance.client;

  static Future<void> kirimPermintaan(PermintaanModel model) async {
    await supabase.from('permintaan_pemilik_lapangan').insert(model.toJson());
  }

  static Future<List<PermintaanModel>> ambilSemuaPermintaan() async {
    final response = await supabase
        .from('permintaan_pemilik_lapangan')
        .select('*, pengguna(nama_lengkap)')
        .order('tanggal_dibuat', ascending: false);

    return (response as List)
        .map((data) => PermintaanModel.fromJson(data))
        .toList();
  }

  static Stream<List<PermintaanModel>> streamPermintaan() {
  return supabase
      .from('permintaan_pemilik_lapangan')
      .stream(primaryKey: ['id'])
      .order('tanggal_dibuat', ascending: false)
      .map<List<PermintaanModel>>(
        (data) => data.map((item) => PermintaanModel.fromJson(item)).toList(),
      );
}

  static Future<PermintaanModel?> ambilPermintaanById(String id) async {
    final response = await supabase
        .from('permintaan_pemilik_lapangan')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return PermintaanModel.fromJson(response);
  }

  static Future<void> accPermintaan(PermintaanModel permintaan) async {
    final idPengguna = permintaan.idPengguna;

    final pengguna = await supabase
        .from('pengguna')
        .select('nama_lengkap')
        .eq('id_pengguna', idPengguna)
        .maybeSingle();

    final namaLengkap = pengguna?['nama_lengkap'] ?? 'Tanpa Nama';

    await supabase
        .from('pemilik_lapangan')
        .insert({
          'id_pengguna': idPengguna,
          'nama_perusahaan': permintaan.namaPerusahaan,
          'info_kontak_tambahan': permintaan.nomorTelepon,
          'status_verifikasi': 'terverifikasi',
        });

    await supabase
        .from('pengguna')
        .update({'peran': 'pemilik'})
        .eq('id_pengguna', idPengguna);

    await supabase
        .from('permintaan_pemilik_lapangan')
        .update({'status': 'approved'})
        .eq('id', permintaan.id);
  }

  static Future<void> rejectPermintaan(String permintaanId) async {
    await supabase
        .from('permintaan_pemilik_lapangan')
        .update({'status': 'rejected'})
        .eq('id', permintaanId);
  }
}
