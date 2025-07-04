import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/models/permintaan_model.dart';
import 'package:gofield/core/services/ownerService/permitaan_service.dart';

class Daftarlapangan extends StatefulWidget {
  const Daftarlapangan({super.key});

  @override
  State<Daftarlapangan> createState() => _DaftarlapanganState();
}

class _DaftarlapanganState extends State<Daftarlapangan> {
  final TextEditingController namaPerusahaan = TextEditingController();
  final TextEditingController deskripsi = TextEditingController();
  final TextEditingController alamatKantor = TextEditingController();
  final TextEditingController nomorTelepon = TextEditingController();
  final TextEditingController email = TextEditingController();

  List<String> urlGambar = []; // For storing uploaded image URLs
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0088E8),
                          Color(0xFF4DACEF),
                          Colors.white,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Daftar Sebagai Pemilik Lapangan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 13,
                    left: 4,
                    child: CustomBackButton(
                      backgroundColor: Colors.transparent,
                      iconColor: Colors.white,
                      onPressed: () {
                        context.go(AppRoutes.userRegisterToOwner);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Upload File (placeholder)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      LinkButton(
                        text: 'Upload Dokumen Perusahaan',
                        size: ButtonSize.small,
                        onPressed: () {
                          // TODO: Implement image upload functionality
                          print('Upload file...');
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Format: JPG, PNG, PDF (Max 5MB)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Nama Perusahaan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: namaPerusahaan,
                  decoration: const InputDecoration(
                    labelText: 'Nama Perusahaan *',
                    hintText: 'Masukkan nama perusahaan/bisnis Anda',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: deskripsi,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Perusahaan',
                    hintText: 'Ceritakan tentang perusahaan dan layanan yang ditawarkan',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Alamat Kantor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: alamatKantor,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Kantor *',
                    hintText: 'Masukkan alamat lengkap kantor/tempat usaha',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Row No Telepon & Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nomorTelepon,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon *',
                          hintText: '+62xxx',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Bisnis *',
                          hintText: 'email@perusahaan.com',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Info Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informasi Penting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Pastikan semua data yang dimasukkan benar dan valid\n'
                        '• Proses verifikasi akan dilakukan dalam 1-3 hari kerja\n'
                        '• Anda akan mendapat notifikasi melalui email setelah verifikasi selesai\n'
                        '• Upload dokumen yang jelas dan mudah dibaca\n'
                        '• Field bertanda (*) wajib diisi',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CancelButton(
                        text: 'Batal',
                        size: ButtonSize.medium,
                        onPressed: isLoading ? null : () {
                          context.go(AppRoutes.userDashboard);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                                                text: isLoading ? 'Mengirim...' : 'Kirim Permintaan',
                        size: ButtonSize.medium,
                        onPressed: isLoading ? null : () {
                          submitPermintaan();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitPermintaan() async {
    // Validation
    if (namaPerusahaan.text.trim().isEmpty) {
      _showErrorSnackBar('Nama perusahaan harus diisi');
      return;
    }

    if (alamatKantor.text.trim().isEmpty) {
      _showErrorSnackBar('Alamat kantor harus diisi');
      return;
    }

    if (nomorTelepon.text.trim().isEmpty) {
      _showErrorSnackBar('Nomor telepon harus diisi');
      return;
    }

    if (email.text.trim().isEmpty) {
      _showErrorSnackBar('Email harus diisi');
      return;
    }

    // Email validation
    if (!_isValidEmail(email.text.trim())) {
      _showErrorSnackBar('Format email tidak valid');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final uuid = Uuid();
    final supabase = Supabase.instance.client;

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Pengguna tidak ditemukan. Silakan login kembali.');
      return;
    }

    final model = PermintaanModel(
      id: uuid.v4(),
      idPengguna: userId,
      namaPerusahaan: namaPerusahaan.text.trim(),
      deskripsi: deskripsi.text.trim().isEmpty ? null : deskripsi.text.trim(),
      alamatKantor: alamatKantor.text.trim(),
      nomorTelepon: nomorTelepon.text.trim(),
      email: email.text.trim(),
      urlGambar: urlGambar.isEmpty ? null : urlGambar,
      status: 'pending',
      tanggalDibuat: DateTime.now(),
    );

    try {
      await PermintaanService.kirimPermintaan(model);
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permintaan berhasil dikirim! Kami akan meninjau dalam 1-3 hari kerja.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        
        context.go(AppRoutes.waitingRegister);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      
      print('Error submitting request: $e');
      _showErrorSnackBar('Gagal mengirim permintaan. Silakan coba lagi.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    namaPerusahaan.dispose();
    deskripsi.dispose();
    alamatKantor.dispose();
    nomorTelepon.dispose();
    email.dispose();
    super.dispose();
  }
}

