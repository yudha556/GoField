# GO SPORT

Aplikasi booking lapangan olahraga yang dikembangkan untuk memenuhi tugas akhir mata kuliah Teknologi Mobile.

## 📱 Tentang Aplikasi

GoSport adalah aplikasi mobile yang memungkinkan pengguna untuk mencari dan memesan lapangan olahraga dengan mudah. Aplikasi ini menghubungkan pengguna dengan pemilik lapangan untuk proses booking yang efisien.

## 🛠 Teknologi yang Digunakan

- **Flutter** - Framework UI untuk pengembangan aplikasi mobile
- **Supabase** - Backend as a Service untuk database dan autentikasi
- **Google Fonts** - Font Roboto untuk konsistensi UI
- **Cupertino Icons** - Icon set untuk iOS style
- **Go Router** - Navigasi dan routing yang powerful
- **Flutter DotEnv** - Manajemen environment variables

## ✨ Fitur Utama

- **Booking Lapangan**
  - Pengguna dan pemilik lapangan
  - Jadwal lapangan
  - Ketersediaan real-time
- **Pencarian Lapangan**
  - Integrasi Google Maps (planned)
  - Pencarian berdasarkan nama lapangan
  - Filter berdasarkan lokasi dan jenis olahraga

## 📋 Prasyarat

Pastikan Anda telah menginstall:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.8.1 atau lebih baru)
- [Dart SDK](https://dart.dev/get-dart) (sudah termasuk dalam Flutter)
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

## 🚀 Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/username/gosport.git
cd gosport
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Setup Environment Variables

#### a. Buat file environment
Buat file `.env.local` di root project (sejajar dengan `pubspec.yaml`):

```bash
touch .env.local
```

#### b. Isi file .env.local
Buka file `.env.local` dan tambahkan konfigurasi berikut:

```env
# Supabase Configuration
SUPABASE_URL=https://puuzxpoumbbdvzjfwjyj.supabase.co
SUPABASE_ANONKEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB1dXp4cG91bWJiZHZ6amZ3anlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3MDE2NzgsImV4cCI6MjA2NDI3NzY3OH0.f2cQf330l5UC8yHzPx1cMHDcQhU9_F9maFI85BR8PS8

# App Configuration
APP_NAME=GoSport
DEBUG_MODE=true

# API Configuration (optional)
API_URL=https://api.gosport.com
```

### 4. Struktur File Environment

Pastikan struktur folder Anda seperti ini:
```
gosport/
├── .env.local          ← File environment di sini
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   └── core/
│       ├── constants/
│       │   └── env.dart
│       └── routes/
└── ...
```

### 5. Verifikasi Instalasi

```bash
flutter doctor
```

Pastikan semua centang hijau atau tidak ada masalah kritis.

### 6. Jalankan Aplikasi

#### Development Mode
```bash
flutter run
```

#### Debug Mode dengan Hot Reload
```bash
flutter run --debug
```

#### Release Mode (untuk testing performa)
```bash
flutter run --release
```

## 🔧 Konfigurasi Tambahan

### Android Setup
Jika mengembangkan untuk Android, pastikan:
1. Android SDK terinstall
2. Emulator atau device fisik terhubung
3. USB Debugging enabled (untuk device fisik)

### iOS Setup (macOS only)
Jika mengembangkan untuk iOS:
1. Xcode terinstall
2. iOS Simulator atau device fisik terhubung
3. Apple Developer Account (untuk deploy ke device)

## 🐛 Troubleshooting

### Error: Environment file not found
```bash
# Pastikan file .env.local ada di root project
ls -la | grep .env

# Jika tidak ada, buat file baru
touch .env.local
```

### Error: Supabase initialization failed
1. Periksa SUPABASE_URL dan SUPABASE_ANONKEY di `.env.local`
2. Pastikan tidak ada spasi atau karakter tersembunyi
3. Verifikasi credentials di Supabase Dashboard

### Error: Package dependencies
```bash
# Clean dan reinstall dependencies
flutter clean
flutter pub get
```

### Error: Build failed
```bash
# Reset Flutter
flutter clean
flutter pub get
flutter pub deps
```


## 🔒 Keamanan

- **Jangan commit file `.env.local`** ke repository
- File `.env.local` sudah ditambahkan ke `.gitignore`
- Gunakan environment variables yang berbeda untuk development dan production

## 📝 Development Commands

```bash
# Menjalankan aplikasi
flutter run

# Build APK untuk Android
flutter build apk

# Build untuk iOS (macOS only)
flutter build ios

# Analyze kode
flutter analyze

# Format kode
flutter format .

# Test aplikasi
flutter test
```

## 🤝 Contributing

1. Fork repository ini
2. Buat branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Contact

Your Name - your.email@example.com

Project Link: [https://github.com/username/gosport](https://github.com/username/gosport)

---

**Happy Coding! 🚀**