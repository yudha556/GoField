class LapanganDetailModel {
  final String id;
  final String idPemilik;
  final String namaLapangan;
  final String deskripsiLapangan;
  final String alamat;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final double? latitude;
  final double? longitude;
  final int kapasitas;
  final String status;
  final Map<String, dynamic>? fasilitas;
  final List<String>? urlGambar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LaneDetailModel>? lanes;
  final String? namaPerusahaan;

  LapanganDetailModel({
    required this.id,
    required this.idPemilik,
    required this.namaLapangan,
    required this.deskripsiLapangan,
    required this.alamat,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.latitude,
    this.longitude,
    required this.kapasitas,
    required this.status,
    this.fasilitas,
    this.urlGambar,
    required this.createdAt,
    required this.updatedAt,
    this.lanes,
    this.namaPerusahaan,
  });

  factory LapanganDetailModel.fromJson(Map<String, dynamic> json) {
    return LapanganDetailModel(
      id: json['id_lapangan'] ?? '',
      idPemilik: json['id_pemilik'] ?? '',
      namaLapangan: json['nama_lapangan'] ?? '',
      deskripsiLapangan: json['deskripsi_lapangan'] ?? '',
      alamat: json['alamat_lapangan'] ?? '',
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      provinsi: json['provinsi'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      kapasitas: json['kapasitas_pemain'] ?? 0,
      status: json['status_lapangan'] ?? '',
      fasilitas: json['fasilitas'],
      namaPerusahaan: json['nama_perusahaan'],
      urlGambar: json['url_gambar'] != null
          ? List<String>.from(json['url_gambar'])
          : null,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      lanes: json['lanes'] != null
          ? (json['lanes'] as List)
                .map((e) => LaneDetailModel.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lapangan': id,
      'id_pemilik': idPemilik,
      'nama_lapangan': namaLapangan,
      'deskripsi_lapangan': deskripsiLapangan,
      'alamat': alamat,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'latitude': latitude,
      'longitude': longitude,
      'kapasitas': kapasitas,
      'status': status,
      'fasilitas': fasilitas,
      'nama_perusahaan': namaPerusahaan,
      'url_gambar': urlGambar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class LaneDetailModel {
  final String id;
  final String idLapangan;
  final String idOlahraga;
  final String namaLane;
  final String deskripsi;
  final int kapasitas;
  final double hargaPerJam;
  final bool aktif;
  final List<String>? urlGambar;
  final String? jenisOlahragaNama;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? namaPerusahaan;

  LaneDetailModel({
    required this.id,
    required this.idLapangan,
    required this.idOlahraga,
    required this.namaLane,
    required this.deskripsi,
    required this.kapasitas,
    required this.hargaPerJam,
    required this.aktif,
    this.urlGambar,
    this.jenisOlahragaNama,
    required this.createdAt,
    required this.updatedAt,
    this.namaPerusahaan
  });

  factory LaneDetailModel.fromJson(Map<String, dynamic> json) {
    return LaneDetailModel(
      id: json['id_lane'] ?? '',
      idLapangan: json['id_lapangan'] ?? '',
      idOlahraga: json['id_olahraga'] ?? '',
      namaLane: json['nama_lane'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kapasitas: json['kapasitas'] ?? 0,
      hargaPerJam: (json['harga_per_jam'] ?? 0).toDouble(),
      aktif: json['aktif'] ?? false,
      namaPerusahaan: json['nama_perusahaan'],
      urlGambar: json['url_gambar'] != null
          ? List<String>.from(json['url_gambar'])
          : null,
      jenisOlahragaNama: json['jenis_olahraga_nama'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lane': id,
      'id_lapangan': idLapangan,
      'id_olahraga': idOlahraga,
      'nama_lane': namaLane,
      'deskripsi': deskripsi,
      'kapasitas': kapasitas,
      'harga_per_jam': hargaPerJam,
      'aktif': aktif,
      'url_gambar': urlGambar,
      'nama_perusahaan': namaPerusahaan,
      'jenis_olahraga_nama': jenisOlahragaNama,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
