class LaneModel {
  final String? id;
  final String idLapangan;
  final String idOlahraga;
  final String namaLane;
  final String deskripsi;
  final int kapasitas;
  final double hargaPerJam;
  final bool aktif;

  LaneModel({
    this.id,
    required this.idLapangan,
    required this.idOlahraga,
    required this.namaLane,
    required this.deskripsi,
    required this.kapasitas,
    required this.hargaPerJam,
    required this.aktif,
  });

  factory LaneModel.fromJson(Map<String, dynamic> json) {
    return LaneModel(
      id: json['id_lane'],
      idLapangan: json['id_lapangan'],
      idOlahraga: json['id_jenis_olahraga'],
      namaLane: json['nama_lane'],
      deskripsi: json['deskripsi'] ?? '',
      kapasitas: json['kapasitas_pemain'],
      hargaPerJam: double.tryParse(json['harga_per_jam'].toString()) ?? 0,
      aktif: json['aktif'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lapangan': idLapangan,
      'id_jenis_olahraga': idOlahraga,
      'nama_lane': namaLane,
      'deskripsi': deskripsi,
      'kapasitas_pemain': kapasitas,
      'harga_per_jam': hargaPerJam,
      'aktif': aktif,
    };
  }
}
