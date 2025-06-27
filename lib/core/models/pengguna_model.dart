class PenggunaModel {
  final String idPengguna;
  final String namaLengkap;
  final String userEmail; // Now included
  final String nomorTelepon;
  final String? alamat;
  final PeranEnum peran;
  final DateTime tanggalDaftar;
  final bool aktif;
  final String? imageUrl;

  PenggunaModel({
    required this.idPengguna,
    required this.namaLengkap,
    required this.userEmail,
    required this.nomorTelepon,
    this.alamat,
    required this.peran,
    required this.tanggalDaftar,
    required this.aktif,
    this.imageUrl,
  });

  factory PenggunaModel.fromJson(Map<String, dynamic> json) {
    return PenggunaModel(
      idPengguna: json['id_pengguna'],
      namaLengkap: json['nama_lengkap'],
      userEmail: json['user_email'],
      nomorTelepon: json['nomor_telepon'],
      alamat: json['alamat'],
      peran: PeranEnum.values.firstWhere(
        (e) => e.name == json['peran'],
        orElse: () => PeranEnum.pengguna,
      ),
      tanggalDaftar: DateTime.parse(json['tanggal_daftar']),
      aktif: json['aktif'] ?? true,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengguna': idPengguna,
      'nama_lengkap': namaLengkap,
      'user_email': userEmail,
      'nomor_telepon': nomorTelepon,
      'alamat': alamat,
      'peran': peran.name,
      'tanggal_daftar': tanggalDaftar.toIso8601String(),
      'aktif': aktif,
      'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'id_pengguna': idPengguna,
      'nama_lengkap': namaLengkap,
      'user_email': userEmail,
      'nomor_telepon': nomorTelepon,
      'alamat': alamat,
      'peran': peran.value,
      // tanggal_daftar dan aktif akan menggunakan default value
    };
  }

  PenggunaModel copyWith({
    String? idPengguna,
    String? namaLengkap,
    String? email,
    String? nomorTelepon,
    String? alamat,
    PeranEnum? peran,
    DateTime? tanggalDaftar,
    bool? aktif,
  }) {
    return PenggunaModel(
      idPengguna: idPengguna ?? this.idPengguna,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      userEmail: email ?? this.userEmail,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      alamat: alamat ?? this.alamat,
      peran: peran ?? this.peran,
      tanggalDaftar: tanggalDaftar ?? this.tanggalDaftar,
      aktif: aktif ?? this.aktif,
    );
  }

  // Helper getters
  String get displayRole => peran.displayName;
  bool get isActive => aktif;
  bool get isAdmin => peran == PeranEnum.admin;
  bool get isPemilik => peran == PeranEnum.pemilik;
  bool get isPengguna => peran == PeranEnum.pengguna;
}

enum PeranEnum {
  admin('admin'),
  pemilik('pemilik'),
  pengguna('pengguna');

  const PeranEnum(this.value);
  final String value;

  static PeranEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return PeranEnum.admin;
      case 'pemilik':
        return PeranEnum.pemilik;
      case 'pengguna':
      default:
        return PeranEnum.pengguna;
    }
  }

  String get displayName {
    switch (this) {
      case PeranEnum.admin:
        return 'Admin';
      case PeranEnum.pemilik:
        return 'Pemilik Lapangan';
      case PeranEnum.pengguna:
        return 'Pengguna';
    }
  }

  String get routeName {
    switch (this) {
      case PeranEnum.admin:
        return 'admin';
      case PeranEnum.pemilik:
        return 'owner';
      case PeranEnum.pengguna:
        return 'user';
    }
  }
}
