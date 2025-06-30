import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/permintaan_model.dart';

class PermintaanService {
  static final supabase = Supabase.instance.client;

  static Future<void> accPermintaan(PermintaanModel permintaan) async {
    final idPengguna = permintaan.idPengguna;

    // 1. Insert ke pemilik_lapangan
    final pemilikRes = await supabase
        .from('pemilik_lapangan')
        .insert({
          'id_pengguna': idPengguna,
          'nama_perusahaan': permintaan.namaLapangan,
          'info_kontak_tambahan': permintaan.nomorTelepon,
          'status_verifikasi': 'terverifikasi',
        })
        .select()
        .single();

    final idPemilik = pemilikRes['id_pemilik'];

    // 2. Insert ke lapangan (untuk setiap banyakLapangan)
    for (int i = 0; i < permintaan.banyakLapangan; i++) {
      await supabase.from('lapangan').insert({
        'id_pemilik': idPemilik,
        'nama_lapangan': '${permintaan.namaLapangan} - ${i + 1}',
        'alamat_lapangan': permintaan.alamat,
        'deskripsi_lapangan': permintaan.deskripsi,
        'harga_per_jam': permintaan.hargaPerJam,
        'kapasitas_pemain': permintaan.kapasitas,
        'status_lapangan': 'tersedia',
        'url_gambar': [], // kosongin dulu
      });
    }

    // 3. Update role pengguna
    await supabase
        .from('pengguna')
        .update({'peran': 'pemilik'})
        .eq('id_pengguna', idPengguna);

    // 4. Update status permintaan
    await supabase
        .from('permintaan_pemilik_lapangan')
        .update({'status': 'approved'})
        .eq('id', permintaan.id);
  }
}
