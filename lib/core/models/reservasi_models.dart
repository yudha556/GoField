class ReservasiModel {
  final String idPengguna;
  final String idLapangan;
  final String idLane;
  final String idJadwal;
  final DateTime tanggalReservasi;
  final String waktuMulai;
  final String waktuSelesai;
  final double durasiJam;
  final double totalHarga;
  final String catatan;
  final String statusReservasi;

  ReservasiModel({
    required this.idPengguna,
    required this.idLapangan,
    required this.idLane,
    required this.idJadwal,
    required this.tanggalReservasi,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.durasiJam,
    required this.totalHarga,
    required this.catatan,
    this.statusReservasi = 'menunggu',
  });

  Map<String, dynamic> toJson() {
    return {
      'id_pengguna': idPengguna,
      'id_lapangan': idLapangan,
      'id_lane': idLane,
      'id_jadwal': idJadwal,
      'tanggal_reservasi': tanggalReservasi.toIso8601String(),
      'waktu_mulai_reservasi': waktuMulai,
      'waktu_selesai_reservasi': waktuSelesai,
      'durasi_jam': durasiJam,
      'total_harga': totalHarga,
      'catatan_reservasi': catatan,
      'status_reservasi': statusReservasi,
    };
  }
}
