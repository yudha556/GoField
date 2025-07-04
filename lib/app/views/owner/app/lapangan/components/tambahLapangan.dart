import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/models/lapangan_model.dart';
import 'package:gofield/core/services/ownerService/lapanganService.dart';
import 'package:gofield/core/constants/app_constans.dart';
import 'package:gofield/core/utils/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahLapangan extends StatefulWidget {
  const TambahLapangan({super.key});

  @override
  State<TambahLapangan> createState() => _TambahLapanganState();
}

class _TambahLapanganState extends State<TambahLapangan> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk form fields
  final _namaLapanganController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _kapasitasController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kabupatenController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _koordinatController = TextEditingController();

  // Form values
  List<String> _selectedFasilitas = [];
  bool _statusLapangan = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaLapanganController.dispose();
    _deskripsiController.dispose();
    _kapasitasController.dispose();
    _alamatController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _koordinatController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Mohon lengkapi semua field yang wajib diisi');
      return false;
    }

    // Validasi koordinat jika diisi
    if (_koordinatController.text.isNotEmpty) {
      final koordinatValidation = Validators.validateCoordinate(
        _koordinatController.text,
      );
      if (koordinatValidation != null) {
        _showErrorSnackBar(koordinatValidation);
        return false;
      }
    }

    return true;
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF0088E8)),
              SizedBox(width: 8),
              Text('Konfirmasi'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apakah Anda yakin ingin menyimpan data lapangan ini?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lapangan: ${_namaLapanganController.text}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kapasitas: ${_kapasitasController.text} orang',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${_statusLapangan ? "Tersedia" : "Tidak Tersedia"}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF0088E8), size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Setelah disimpan, Anda akan diarahkan ke halaman tambah lane.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0088E8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _submitForm();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Simpan & Lanjut',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String lapanganId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lapangan Berhasil Disimpan!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Lapangan "${_namaLapanganController.text}" telah berhasil disimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF0088E8),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Selanjutnya, tambahkan lane untuk lapangan ini.',
                        style: TextStyle(
                          color: Color(0xFF0088E8),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(AppRoutes.ownerLapanganPage);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Nanti Saja'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(
                        '${AppRoutes.tambahLane}?lapanganId=$lapanganId&namaLapangan=${Uri.encodeComponent(_namaLapanganController.text)}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Tambah Lane',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error, color: Colors.red, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal Menyimpan Lapangan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.orange, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Periksa koneksi internet dan coba lagi.',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _showSuccessSnackBar('Memproses data lapangan...');

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User tidak ditemukan. Silakan login kembali.');
      }

      print('Current user ID: ${user.id}');
      final pemilikRes = await Supabase.instance.client
          .from('pemilik_lapangan')
          .select('id_pemilik')
          .eq('id_pengguna', user.id)
          .maybeSingle();

      if (pemilikRes == null) {
        throw Exception(
          'Data pemilik lapangan tidak ditemukan. Pastikan Anda sudah terdaftar sebagai pemilik lapangan.',
        );
      }

      final idPemilik = pemilikRes['id_pemilik'];
      print('Pemilik ID: $idPemilik');

      // Parse koordinat jika ada
      double? latitude;
      double? longitude;
      if (_koordinatController.text.isNotEmpty) {
        final koordinatParts = _koordinatController.text.split(',');
        if (koordinatParts.length == 2) {
          latitude = double.tryParse(koordinatParts[0].trim());
          longitude = double.tryParse(koordinatParts[1].trim());
        }
      }

      final lapanganModel = LapanganModel(
        idPemilik: idPemilik,
        namaLapangan: _namaLapanganController.text.trim(),
        deskripsiLapangan: _deskripsiController.text
            .trim(), 
        alamat: _alamatController.text.trim(),
        // hargaPerJam: double.parse(
        //   _hargaController.text,
        // ),
        kapasitas: int.parse(_kapasitasController.text),
        status: _statusLapangan
            ? AppConstants.statusTersedia
            : AppConstants.statusTidakTersedia, 
        // urlGambar: [],
        kecamatan: _kecamatanController.text.trim().isEmpty
            ? null
            : _kecamatanController.text.trim(),
        kabupaten: _kabupatenController.text.trim().isEmpty
            ? null
            : _kabupatenController.text.trim(),
        provinsi: _provinsiController.text.trim().isEmpty
            ? null
            : _provinsiController.text.trim(),
        latitude: latitude,
        longitude: longitude,
        // tipeLapangan: _selectedTipeLapangan,
        fasilitas: _selectedFasilitas.isNotEmpty
            ? {'fasilitas': _selectedFasilitas}
            : null,
      );

      print('Saving lapangan: ${lapanganModel.toJson()}'); 

      // Simpan lapangan ke database
      final idLapangan = await LapanganService.tambahLapangan(lapanganModel);
      print('Lapangan saved with ID: $idLapangan');

      _showSuccessSnackBar('Lapangan berhasil disimpan!');

      await Future.delayed(const Duration(milliseconds: 500));

      // Show success dialog
      if (mounted) {
        _showSuccessDialog(idLapangan);
      }
    } catch (e) {
      print('Error saving lapangan: $e'); 
      _showErrorSnackBar('Gagal menyimpan lapangan');
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Header
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0088E8), Color(0xFF4DACEF), Colors.white],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                context.go(AppRoutes.ownerLapanganPage);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Tambah Lapangan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Lengkapi informasi lapangan Anda untuk menarik lebih banyak pelanggan',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Form Container
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(key: _formKey, child: _buildFormContent()),
                ),
              ),
            ),

            // Bottom spacing
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informasi Lapangan', Icons.info_outline),
        const SizedBox(height: 24),

        _buildModernTextField(
          controller: _namaLapanganController,
          label: 'Nama Lapangan',
          hint: 'Masukkan nama lapangan',
          icon: Icons.sports_soccer,
          isRequired: true,
          validator: (value) =>
              Validators.validateRequired(value, 'Nama lapangan'),
        ),
        const SizedBox(height: 20),

        _buildModernTextField(
          controller: _deskripsiController,
          label: 'Deskripsi Lapangan',
          hint: 'Ceritakan tentang lapangan Anda (opsional)',
          icon: Icons.description,
          maxLines: 3,
        ),
        const SizedBox(height: 20),

        _buildModernTextField(
          controller: _kapasitasController,
          label: 'Kapasitas Pemain',
          hint: '0',
          icon: Icons.people,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixText: 'orang',
          isRequired: true,
          validator: (value) => Validators.validateCapacity(value),
        ),
        const SizedBox(height: 32),

        _buildSectionTitle('Lokasi', Icons.location_on),
        const SizedBox(height: 24),

        _buildModernTextField(
          controller: _alamatController,
          label: 'Alamat Lengkap',
          hint: 'Jl. Contoh No. 123',
          icon: Icons.home,
          maxLines: 2,
          isRequired: true,
          validator: (value) => Validators.validateRequired(value, 'Alamat'),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _buildModernTextField(
                controller: _kecamatanController,
                label: 'Kecamatan',
                hint: 'Nama kecamatan',
                icon: Icons.location_city,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernTextField(
                controller: _kabupatenController,
                label: 'Kabupaten/Kota',
                hint: 'Nama kabupaten/kota',
                icon: Icons.location_city,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildModernTextField(
          controller: _provinsiController,
          label: 'Provinsi',
          hint: 'Nama provinsi',
          icon: Icons.map,
        ),
        const SizedBox(height: 20),

        // Koordinat Lokasi
        _buildModernTextField(
          controller: _koordinatController,
          label: 'Koordinat Lokasi',
          hint: 'Contoh: -6.200000, 106.816666',
          icon: Icons.gps_fixed,
          validator: (value) => Validators.validateCoordinate(value),
          suffixIcon: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF0088E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.map, color: Colors.white, size: 20),
              onPressed: () {
                _showErrorSnackBar('Map picker akan diimplementasi nanti');
              },
            ),
          ),
        ),
        const SizedBox(height: 32),

        _buildSectionTitle('Fasilitas & Status', Icons.settings),
        const SizedBox(height: 24),

        // Fasilitas Tambahan
        _buildModernFasilitas(),
        const SizedBox(height: 24),

        // Status Lapangan
        _buildModernStatusToggle(),
        const SizedBox(height: 32),

        // Submit Button
        _buildModernSubmitButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0088E8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF0088E8), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    String? suffixText,
    Widget? suffixIcon,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(icon, color: const Color(0xFF0088E8), size: 20),
            ),
            prefixText: prefixText,
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildModernFasilitas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fasilitas Tambahan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.fasilitasOptions.map((fasilitas) {
            final isSelected = _selectedFasilitas.contains(fasilitas);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFasilitas.remove(fasilitas);
                  } else {
                    _selectedFasilitas.add(fasilitas);
                  }
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0088E8)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0088E8)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(Icons.check, size: 16, color: Colors.white),
                    if (isSelected) const SizedBox(width: 4),
                    Text(
                      fasilitas,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildModernStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _statusLapangan
                  ? const Color(0xFF0088E8).withOpacity(0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _statusLapangan ? Icons.toggle_on : Icons.toggle_off,
              color: _statusLapangan ? const Color(0xFF0088E8) : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Lapangan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  _statusLapangan
                      ? 'Tersedia - Lapangan dapat dipesan'
                      : 'Tidak Tersedia - Lapangan tidak dapat dipesan',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: _statusLapangan,
            onChanged: (value) {
              setState(() {
                _statusLapangan = value;
              });
            },
            activeColor: const Color(0xFF0088E8),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _isLoading
            ? const LinearGradient(colors: [Colors.grey, Colors.grey])
            : const LinearGradient(
                colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isLoading
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF0088E8).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading
              ? null
              : () {
                  // Add haptic feedback
                  HapticFeedback.lightImpact();

                  if (_validateForm()) {
                    _showSubmitDialog();
                  }
                },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Menyimpan...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Simpan Lapangan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
