class PenggunaModel {
  final String idPengguna; // UUID from auth.users.id
  final String namaLengkap;
  final String email;
  final String? nomorTelepon;
  final String? alamat;
  final PeranEnum peran;
  final DateTime tanggalDaftar;
  final bool aktif;

  PenggunaModel({
    required this.idPengguna,
    required this.namaLengkap,
    required this.email,
    this.nomorTelepon,
    this.alamat,
    required this.peran,
    required this.tanggalDaftar,
    required this.aktif,
  });

  factory PenggunaModel.fromJson(Map<String, dynamic> json) {
    return PenggunaModel(
      idPengguna: json['id_pengguna'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      email: json['email'] as String,
      nomorTelepon: json['nomor_telepon'] as String?,
      alamat: json['alamat'] as String?,
      peran: PeranEnum.fromString(json['peran'] as String),
      tanggalDaftar: DateTime.parse(json['tanggal_daftar'] as String),
      aktif: json['aktif'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengguna': idPengguna,
      'nama_lengkap': namaLengkap,
      'email': email,
      'nomor_telepon': nomorTelepon,
      'alamat': alamat,
      'peran': peran.value,
      'tanggal_daftar': tanggalDaftar.toIso8601String(),
      'aktif': aktif,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'id_pengguna': idPengguna,
      'nama_lengkap': namaLengkap,
      'email': email,
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
      email: email ?? this.email,
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
