class JenisOlahragaModel {
  final String id;
  final String namaJenis;
  final String? deskripsi;
  final String? urlIkon;
  final bool aktif;

  JenisOlahragaModel({
    required this.id,
    required this.namaJenis,
    this.deskripsi,
    this.urlIkon,
    required this.aktif,
  });

  factory JenisOlahragaModel.fromJson(Map<String, dynamic> json) {
    return JenisOlahragaModel(
      id: json['id_jenis_olahraga'],
      namaJenis: json['nama_jenis'],
      deskripsi: json['deskripsi'],
      urlIkon: json['url_ikon'],
      aktif: json['aktif'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_jenis': namaJenis,
      'deskripsi': deskripsi,
      'url_ikon': urlIkon,
      'aktif': aktif,
    };
  }
}
