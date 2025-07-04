class LapanganModel {
  final String? id;
  final String idPemilik;
  final String namaLapangan;
  final String deskripsiLapangan;
  final String alamat;
  // final double hargaPerJam;
  final int kapasitas;
  final String status;
  // final List<String> urlGambar;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final double? latitude;
  final double? longitude;
  // final String? tipeLapangan;
  final Map<String, dynamic>? fasilitas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LapanganModel({
    this.id,
    required this.idPemilik,
    required this.namaLapangan,
    required this.deskripsiLapangan,
    required this.alamat,
    // required this.hargaPerJam,
    required this.kapasitas,
    required this.status,
    // required this.urlGambar,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.latitude,
    this.longitude,
    // this.tipeLapangan,
    this.fasilitas,
    this.createdAt,
    this.updatedAt,
  });

  factory LapanganModel.fromJson(Map<String, dynamic> json) {
    return LapanganModel(
      id: json['id_lapangan'],
      idPemilik: json['id_pemilik'],
      namaLapangan: json['nama_lapangan'],
      deskripsiLapangan: json['deskripsi_lapangan'],
      alamat: json['alamat_lapangan'],
      // hargaPerJam: double.tryParse(json['harga_per_jam'].toString()) ?? 0,
      kapasitas: json['kapasitas_pemain'],
      status: json['status_lapangan'],
      // List<String>.from(json['url_gambar'] ?? []),
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      provinsi: json['provinsi'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      // tipeLapangan: json['tipe_lapangan'],
      fasilitas: json['fasilitas'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pemilik': idPemilik,
      'nama_lapangan': namaLapangan,
      'deskripsi_lapangan': deskripsiLapangan,
      'alamat_lapangan': alamat,
      // 'harga_per_jam': hargaPerJam,
      'kapasitas_pemain': kapasitas,
      'status_lapangan': status,
      // 'url_gambar': urlGambar,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'latitude': latitude,
      'longitude': longitude,
      //'tipe_lapangan': tipeLapangan,
      'fasilitas': fasilitas,
    };
  }
}
