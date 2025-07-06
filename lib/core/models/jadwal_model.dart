class JadwalKetersediaanModel {
  final String idJadwal;
  final String idLane;
  final DateTime tanggal;
  final String waktuMulai;
  final String waktuSelesai;
  final String status;

  JadwalKetersediaanModel({
    required this.idJadwal,
    required this.idLane,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.status,
  });

  factory JadwalKetersediaanModel.fromJson(Map<String, dynamic> json) {
    return JadwalKetersediaanModel(
      idJadwal: json['id_jadwal'],
      idLane: json['id_lane'],
      tanggal: DateTime.parse(json['tanggal_tersedia']),
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      status: json['status_ketersediaan'],
    );
  }
}
