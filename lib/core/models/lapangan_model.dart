class LapanganModel {
  final String? id;
  final String idPemilik;
  final String namaLapangan;
  final String deskripsiLapangan;
  final String alamat;
  final int kapasitas;
  final String statusOperasional;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? fasilitas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LapanganModel({
    this.id,
    required this.idPemilik,
    required this.namaLapangan,
    required this.deskripsiLapangan,
    required this.alamat,
    required this.kapasitas,
    required this.statusOperasional,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.latitude,
    this.longitude,
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
      kapasitas: json['kapasitas_pemain'],
      statusOperasional: json['status_lapangan']?.toString() ?? 'buka',
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      provinsi: json['provinsi'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
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
      'kapasitas_pemain': kapasitas,
      'status_lapangan': statusOperasional,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'latitude': latitude,
      'longitude': longitude,
      'fasilitas': fasilitas,
    };
  }

  bool get isBuka => statusOperasional == 'buka';
  bool get isTutup => statusOperasional == 'tutup';
  bool get isMaintenance => statusOperasional == 'maintenance';

  String get statusText {
    switch (statusOperasional) {
      case 'buka':
        return 'Buka';
      case 'tutup':
        return 'Tutup';
      case 'maintenance':
        return 'Maintenance';
      default:
        return statusOperasional;
    }
  }
  
}
