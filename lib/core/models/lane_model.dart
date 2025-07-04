class LaneModel {
  final String? id;
  final String idLapangan;
  final String idOlahraga;
  final String namaLane;
  final String deskripsi;
  final int kapasitas;
  final double hargaPerJam;
  final bool aktif;
  final DateTime? createdAt; 
  final DateTime? updatedAt;
  
  LaneModel({
    this.id,
    required this.idLapangan,
    required this.idOlahraga,
    required this.namaLane,
    required this.deskripsi,
    required this.kapasitas,
    required this.hargaPerJam,
    required this.aktif,
    this.createdAt,
    this.updatedAt,
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
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  //  schema DB
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

  LaneModel copyWith({
    String? id,
    String? idLapangan,
    String? idOlahraga,
    String? namaLane,
    String? deskripsi,
    int? kapasitas,
    double? hargaPerJam,
    bool? aktif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaneModel(
      id: id ?? this.id,
      idLapangan: idLapangan ?? this.idLapangan,
      idOlahraga: idOlahraga ?? this.idOlahraga,
      namaLane: namaLane ?? this.namaLane,
      deskripsi: deskripsi ?? this.deskripsi,
      kapasitas: kapasitas ?? this.kapasitas,
      hargaPerJam: hargaPerJam ?? this.hargaPerJam,
      aktif: aktif ?? this.aktif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'LaneModel(id: $id, idLapangan: $idLapangan, idOlahraga: $idOlahraga, namaLane: $namaLane, kapasitas: $kapasitas, hargaPerJam: $hargaPerJam, aktif: $aktif, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaneModel &&
        other.id == id &&
        other.idLapangan == idLapangan &&
        other.idOlahraga == idOlahraga &&
        other.namaLane == namaLane &&
        other.deskripsi == deskripsi &&
        other.kapasitas == kapasitas &&
        other.hargaPerJam == hargaPerJam &&
        other.aktif == aktif &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idLapangan.hashCode ^
        idOlahraga.hashCode ^
        namaLane.hashCode ^
        deskripsi.hashCode ^
        kapasitas.hashCode ^
        hargaPerJam.hashCode ^
        aktif.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
