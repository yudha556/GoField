class AppConstants {
  // Validation Constants
  static const int minPrice = 10000;
  static const int maxCapacity = 100;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImages = 5;
  
  // Field Types
  static const List<String> tipeLapanganOptions = [
    'Indoor',
    'Outdoor',
    'Semi Indoor',
  ];

  static const List<String> fasilitasOptions = [
    'Parkir',
    'Toilet',
    'Kantin',
    'Mushola',
    'AC',
    'Sound System',
    'Tribun',
    'Ruang Ganti',
    'WiFi',
    'CCTV',
  ];

  // Status Options
  static const String statusTersedia = 'tersedia';
  static const String statusTidakTersedia = 'tidak_tersedia';
  
  // Error Messages
  static const String errorUserNotFound = 'User tidak ditemukan. Silakan login kembali.';
  static const String errorPemilikNotFound = 'Data pemilik lapangan tidak ditemukan.';
  static const String errorSessionExpired = 'Sesi login telah berakhir. Silakan login kembali.';
    static const String errorNetworkConnection = 'Periksa koneksi internet Anda.';
  
  // Success Messages
  static const String successLapanganSaved = 'Data lapangan berhasil disimpan!';
  static const String successLaneAdded = 'Lane berhasil ditambahkan';
  static const String successLaneUpdated = 'Lane berhasil diperbarui';
  static const String successLaneDeleted = 'Lane berhasil dihapus';
}

