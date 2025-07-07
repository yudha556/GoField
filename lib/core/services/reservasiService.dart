import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/reservasi_models.dart';

class ReservasiService {
  final supabase = Supabase.instance.client;

  Future<String?> buatReservasi(ReservasiModel reservasi) async {
    try {
      final response = await supabase
          .from('reservasi')
          .insert(reservasi.toJson())
          .select()
          .single();

      if (response == null || response['id_reservasi'] == null) {
        throw Exception('Gagal membuat reservasi');
      }
      return response['id_reservasi'] as String;
    } catch (e) {
      throw Exception('Error membuat reservasi: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRiwayatReservasi(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from('reservasi')
          .select('''
            id_reservasi, tanggal_reservasi, waktu_mulai_reservasi, 
            waktu_selesai_reservasi, total_harga, status_reservasi,
            lapangan(nama_lapangan), 
            lane_lapangan(nama_lane)
          ''')
          .eq('id_pengguna', userId)
          .order('tanggal_reservasi', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error mengambil riwayat reservasi: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchReservasiUntukOwner(
    String userId,
  ) async {
    try {
      // STEP 1: Cari id_pemilik dari user yang login
      final pemilikResult = await supabase
          .from('pemilik_lapangan')
          .select('id_pemilik')
          .eq('id_pengguna', userId)
          .maybeSingle(); // pakai maybeSingle biar aman kalau null

      final idPemilik = pemilikResult?['id_pemilik'];
      if (idPemilik == null) {
        print('Pemilik tidak ditemukan untuk userId: $userId');
        return [];
      }

      print('Dapat id_pemilik: $idPemilik');

      // STEP 2: Ambil reservasi untuk lapangan-lapangan milik pemilik ini
      final response = await supabase
          .from('reservasi')
          .select('''
          id_reservasi, 
          tanggal_reservasi, 
          waktu_mulai_reservasi, 
          waktu_selesai_reservasi, 
          total_harga, 
          status_reservasi,
          catatan_reservasi,
          durasi_jam,
          lapangan!inner(
            id_lapangan,
            id_pemilik, 
            nama_lapangan,
            alamat_lapangan
          ),
          lane_lapangan(
            id_lane,
            nama_lane
          ),
          pengguna(
            id_pengguna,
            nama_lengkap, 
            nomor_telepon,
            user_email
          )
        ''')
          .eq('lapangan.id_pemilik', idPemilik)
          .order('tanggal_reservasi', ascending: false)
          .order('waktu_mulai_reservasi', ascending: true);

      print('Total reservasi ditemukan: ${response.length}');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error di fetchReservasiUntukOwner: $e');
      throw Exception('Error mengambil reservasi untuk owner: ${e.toString()}');
    }
  }

  Future<void> updateStatusReservasi(
    String idReservasi,
    String newStatus,
  ) async {
    try {
      await supabase
          .from('reservasi')
          .update({
            'status_reservasi': newStatus,
            'tanggal_diperbarui': DateTime.now().toIso8601String(),
          })
          .eq('id_reservasi', idReservasi);

      print(
        'Status updated successfully for reservation: $idReservasi to $newStatus',
      );
    } catch (e) {
      print('Error updating status: $e');
      throw Exception('Error mengubah status reservasi: ${e.toString()}');
    }
  }

  // Method tambahan untuk mendapatkan detail reservasi
  Future<Map<String, dynamic>?> getDetailReservasi(String idReservasi) async {
    try {
      final response = await supabase
          .from('reservasi')
          .select('''
            id_reservasi, tanggal_reservasi, waktu_mulai_reservasi, 
            waktu_selesai_reservasi, total_harga, status_reservasi,
            catatan_reservasi, durasi_jam,
            lapangan(nama_lapangan, alamat_lapangan),
            lane_lapangan(nama_lane),
            pengguna(nama_lengkap, nomor_telepon, user_email)
          ''')
          .eq('id_reservasi', idReservasi)
          .single();

      return response;
    } catch (e) {
      throw Exception('Error mengambil detail reservasi: ${e.toString()}');
    }
  }

  // Method untuk mendapatkan statistik reservasi owner
  Future<Map<String, int>> getStatistikReservasiOwner(String ownerId) async {
    try {
      final response = await supabase
          .from('reservasi')
          .select('''
            status_reservasi,
            lapangan!inner(id_pemilik)
          ''')
          .eq('lapangan.id_pemilik', ownerId)
          .order('tanggal_reservasi', ascending: false);

      final allReservasi = List<Map<String, dynamic>>.from(response);

      int pending = 0;
      int diterima = 0;
      int ditolak = 0;
      int selesai = 0;

      for (final reservasi in allReservasi) {
        final status = reservasi['status_reservasi']?.toString().toLowerCase();
        switch (status) {
          case 'menunggu':
          case 'pending':
            pending++;
            break;
          case 'diterima':
          case 'dikonfirmasi':
            diterima++;
            break;
          case 'dibatalkan':
            ditolak++;
            break;
          case 'selesai':
            selesai++;
            break;
        }
      }

      return {
        'pending': pending,
        'diterima': diterima,
        'ditolak': ditolak,
        'selesai': selesai,
        'total': allReservasi.length,
      };
    } catch (e) {
      throw Exception('Error mengambil statistik: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getOwnerLapangan(String ownerId) async {
    try {
      final response = await supabase
          .from('lapangan')
          .select('*')
          .eq('id_pemilik', ownerId);

      print('Owner lapangan: $response');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting owner lapangan: $e');
      throw Exception('Error mengambil lapangan owner: ${e.toString()}');
    }
  }

  Future<int> getTotalReservasiOwner(String userId) async {
    final response = await fetchReservasiUntukOwner(userId);
    return response.fold<int>(
      0,
      (sum, item) => sum + ((item['total_harga'] ?? 0) as num).toInt(),
    );
  }

  Future<int> getTotalReservasiCount(String userId) async {
    final response = await fetchReservasiUntukOwner(userId);
    return response.length;
  }

  static Future<int> getTotalReservasi() async {
    final response = await Supabase.instance.client
        .from('reservasi')
        .select('id_reservasi');

    return response.length;
  }

  static Future<Map<int, int>> getReservasiPerHari() async {
  final response = await Supabase.instance.client
      .from('reservasi')
      .select('tanggal_reservasi');

  final Map<int, int> countPerDay = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
  };

  for (var item in response) {
    final tanggal = DateTime.parse(item['tanggal_reservasi']);
    final weekdayIndex = tanggal.weekday % 7; // Flutter: Senin = 1 → Index = 1
    countPerDay[weekdayIndex] = countPerDay[weekdayIndex]! + 1;
  }

  return countPerDay;
}

}
