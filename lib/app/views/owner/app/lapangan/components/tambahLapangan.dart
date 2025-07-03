import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/models/lapangan_model.dart';
import 'package:gofield/core/models/lane_model.dart';
import 'package:gofield/core/models/jenisOlahraga_model.dart';
import 'package:gofield/core/services/lapanganService.dart';
import 'package:gofield/core/services/laneService.dart';
import 'package:gofield/core/services/jenisOlahragaService.dart';
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
  final _hargaController = TextEditingController();
  final _kapasitasController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kabupatenController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _koordinatController = TextEditingController();

  // Dropdown values
  String? _selectedTipeLapangan;
  String? _selectedJenisOlahraga;
  List<String> _selectedFasilitas = [];
  bool _statusLapangan = true;

  // Lane form data
  List<LaneData> _lanes = [];
  bool _showLaneForm = false;

  // Data dari database
  List<JenisOlahragaModel> _jenisOlahragaList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJenisOlahraga();
  }

  @override
  void dispose() {
    _namaLapanganController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _kapasitasController.dispose();
    _alamatController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _koordinatController.dispose();
    super.dispose();
  }

  Future<void> _loadJenisOlahraga() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final jenisOlahraga = await JenisOlahragaService.ambilSemuaJenisOlahraga();
      
      if (mounted) {
        setState(() {
          _jenisOlahragaList = jenisOlahraga;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        print('Error loading jenis olahraga: $e');
        _showErrorSnackBar('Gagal memuat data jenis olahraga: ${e.toString()}');
      }
    }
  }

  Future<void> _refreshJenisOlahraga() async {
    _showLoadingDialog('Memuat ulang data jenis olahraga...');
    
    try {
      await _loadJenisOlahraga();
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showSuccessSnackBar('Data jenis olahraga berhasil dimuat ulang');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorSnackBar('Gagal memuat ulang data: ${e.toString()}');
      }
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
                  ),
                  const SizedBox(height: 16),
                  Text(message),
                ],
              ),
            ),
          ),
        );
      },
    );
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  bool _isDuplicateLaneName(String namaLane) {
    return _lanes.any((lane) => 
      lane.namaLane.toLowerCase() == namaLane.toLowerCase());
  }

  bool _validateMainForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedTipeLapangan == null) {
      _showErrorSnackBar('Pilih tipe lapangan');
      return false;
    }

    if (_selectedJenisOlahraga == null) {
      _showErrorSnackBar('Pilih jenis olahraga');
      return false;
    }

    // Validasi koordinat jika diisi
    if (_koordinatController.text.isNotEmpty) {
      final koordinatValidation = Validators.validateCoordinate(_koordinatController.text);
      if (koordinatValidation != null) {
        _showErrorSnackBar(koordinatValidation);
        return false;
      }
    }

    return true;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaLapanganController.clear();
    _deskripsiController.clear();
    _hargaController.clear();
    _kapasitasController.clear();
    _alamatController.clear();
    _kecamatanController.clear();
    _kabupatenController.clear();
    _provinsiController.clear();
    _koordinatController.clear();
    
    setState(() {
      _selectedTipeLapangan = null;
      _selectedJenisOlahraga = null;
      _selectedFasilitas.clear();
      _statusLapangan = true;
      _lanes.clear();
      _showLaneForm = false;
    });
  }

  void _showDeleteLaneDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Hapus Lane'),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus lane "${_lanes[index].namaLane}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _lanes.removeAt(index);
                });
                Navigator.of(context).pop();
                _showSuccessSnackBar(AppConstants.successLaneDeleted);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _showEditLaneDialog(int index) {
    final lane = _lanes[index];
    final laneFormKey = GlobalKey<FormState>();
    final namaLaneController = TextEditingController(text: lane.namaLane);
    final deskripsiLaneController = TextEditingController(text: lane.deskripsi);
    final kapasitasLaneController = TextEditingController(text: lane.kapasitas.toString());
    final hargaLaneController = TextEditingController(text: lane.hargaPerJam.toString());
    String? selectedJenisOlahragaLane = lane.jenisOlahraga;
    bool statusLane = lane.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit, color: Color(0xFF0088E8)),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Edit Lane: ${lane.namaLane}')),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Form(
                    key: laneFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nama Lane
                        TextFormField(
                          controller: namaLaneController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Lane *',
                            prefixIcon: Icon(Icons.label),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama lane tidak boleh kosong';
                            }
                            // Check duplikasi kecuali untuk lane yang sedang diedit
                            if (value.trim() != lane.namaLane && 
                                _isDuplicateLaneName(value.trim())) {
                              return 'Nama lane sudah digunakan';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Jenis Olahraga
                        DropdownButtonFormField<String>(
                          value: selectedJenisOlahragaLane,
                          decoration: const InputDecoration(
                            labelText: 'Jenis Olahraga *',
                            prefixIcon: Icon(Icons.sports),
                          ),
                          items: _jenisOlahragaList.map((jenisOlahraga) {
                            return DropdownMenuItem<String>(
                              value: jenisOlahraga.namaJenis,
                              child: Text(jenisOlahraga.namaJenis),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedJenisOlahragaLane = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih jenis olahraga';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Deskripsi
                        TextFormField(
                          controller: deskripsiLaneController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                            prefixIcon: Icon(Icons.description),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Kapasitas dan Harga
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: kapasitasLaneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  labelText: 'Kapasitas *',
                                  suffixText: 'orang',
                                  prefixIcon: Icon(Icons.people),
                                ),
                                validator: (value) => Validators.validateCapacity(value),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: hargaLaneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  labelText: 'Harga/Jam *',
                                  prefixText: 'Rp ',
                                  prefixIcon: Icon(Icons.attach_money),
                                ),
                                validator: (value) => Validators.validatePrice(value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Status
                        SwitchListTile(
                          title: const Text('Status Aktif'),
                          subtitle: Text(statusLane ? 'Lane dapat dipesan' : 'Lane tidak dapat dipesan'),
                          value: statusLane,
                          onChanged: (value) {
                            setDialogState(() {
                              statusLane = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                                        if (laneFormKey.currentState!.validate() && selectedJenisOlahragaLane != null) {
                      setState(() {
                        _lanes[index] = LaneData(
                          namaLane: namaLaneController.text.trim(),
                          jenisOlahraga: selectedJenisOlahragaLane!,
                          deskripsi: deskripsiLaneController.text.trim(),
                          kapasitas: int.parse(kapasitasLaneController.text),
                          hargaPerJam: int.parse(hargaLaneController.text),
                          status: statusLane,
                        );
                      });
                      Navigator.of(context).pop();
                      _showSuccessSnackBar(AppConstants.successLaneUpdated);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showModernSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
              Text(
                'Lapangan: ${_namaLapanganController.text}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (_lanes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Jumlah Lane: ${_lanes.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                      'Simpan',
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
                'Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.successLapanganSaved,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              if (_lanes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${_lanes.length} lane berhasil ditambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.ownerLapanganPage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Kembali ke Daftar Lapangan'),
              ),
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
                child: const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal Menyimpan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Tutup'),
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

    // Show loading dialog
    _showLoadingDialog('Menyimpan data lapangan...');

    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception(AppConstants.errorUserNotFound);
      }

      // Get pemilik lapangan ID
      final pemilikRes = await Supabase.instance.client
          .from('pemilik_lapangan')
          .select('id_pemilik')
          .eq('id_pengguna', user.id)
          .single();

      final idPemilik = pemilikRes['id_pemilik'];

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

      // Buat model lapangan
      final lapanganModel = LapanganModel(
        idPemilik: idPemilik,
        namaLapangan: _namaLapanganController.text.trim(),
        deskripsiLapangan: _deskripsiController.text.trim(),
        alamat: _alamatController.text.trim(),
        hargaPerJam: double.parse(_hargaController.text),
        kapasitas: int.parse(_kapasitasController.text),
        status: _statusLapangan ? AppConstants.statusTersedia : AppConstants.statusTidakTersedia,
        urlGambar: [], // Nanti diimplementasikan untuk upload gambar
        kecamatan: _kecamatanController.text.trim(),
        kabupaten: _kabupatenController.text.trim(),
        provinsi: _provinsiController.text.trim(),
        latitude: latitude,
        longitude: longitude,
        tipeLapangan: _selectedTipeLapangan,
        fasilitas: _selectedFasilitas.isNotEmpty
            ? {'fasilitas': _selectedFasilitas}
            : null,
      );

      print('Saving lapangan: ${lapanganModel.toJson()}'); // Debug log

      // Simpan lapangan ke database
      final idLapangan = await LapanganService.tambahLapangan(lapanganModel);
      print('Lapangan saved with ID: $idLapangan'); // Debug log

      // Simpan lanes jika ada
      if (_lanes.isNotEmpty) {
        print('Saving ${_lanes.length} lanes...'); // Debug log
        
        List<LaneModel> laneModels = [];

        for (var laneData in _lanes) {
          print('Processing lane: ${laneData.namaLane} - ${laneData.jenisOlahraga}'); // Debug log
          
          // Cari ID jenis olahraga berdasarkan nama
          final jenisOlahraga = await JenisOlahragaService.ambilJenisOlahragaByNama(
            laneData.jenisOlahraga,
          );

          if (jenisOlahraga != null) {
            final laneModel = LaneModel(
              idLapangan: idLapangan,
              idOlahraga: jenisOlahraga.id,
              namaLane: laneData.namaLane,
              deskripsi: laneData.deskripsi,
              kapasitas: laneData.kapasitas,
              hargaPerJam: laneData.hargaPerJam.toDouble(),
              aktif: laneData.status,
            );
            
            print('Lane model created: ${laneModel.toJson()}'); // Debug log
            laneModels.add(laneModel);
          } else {
            print('Jenis olahraga not found: ${laneData.jenisOlahraga}'); // Debug log
            throw Exception('Jenis olahraga "${laneData.jenisOlahraga}" tidak ditemukan');
          }
        }

        if (laneModels.isNotEmpty) {
          print('Saving ${laneModels.length} lane models to database...'); // Debug log
          await LaneService.tambahMultipleLanes(laneModels);
          print('Lanes saved successfully!'); // Debug log
        }
      }

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success dialog
      _showSuccessDialog();

    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      print('Error saving lapangan: $e'); // Debug log

      // Show error dialog
      _showErrorDialog('Gagal menyimpan data: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
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
                      // Header dengan back button
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
                      // Subtitle
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

        // Nama Lapangan
        _buildModernTextField(
          controller: _namaLapanganController,
          label: 'Nama Lapangan',
          hint: 'Masukkan nama lapangan',
          icon: Icons.sports_soccer,
          isRequired: true,
          validator: (value) => Validators.validateRequired(value, 'Nama lapangan'),
        ),
        const SizedBox(height: 20),

        // Deskripsi Lapangan
        _buildModernTextField(
          controller: _deskripsiController,
          label: 'Deskripsi Lapangan',
          hint: 'Ceritakan tentang lapangan Anda',
          icon: Icons.description,
          maxLines: 3,
          isRequired: true,
          validator: (value) => Validators.validateRequired(value, 'Deskripsi lapangan'),
        ),
        const SizedBox(height: 20),

        // Row untuk Tipe dan Jenis Olahraga
        Row(
          children: [
            Expanded(
              child: _buildModernDropdown(
                label: 'Tipe Lapangan',
                value: _selectedTipeLapangan,
                items: AppConstants.tipeLapanganOptions,
                icon: Icons.home,
                onChanged: (value) {
                  setState(() {
                    _selectedTipeLapangan = value;
                  });
                },
                isRequired: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernDropdown(
                label: 'Jenis Olahraga',
                value: _selectedJenisOlahraga,
                items: _jenisOlahragaList.map((e) => e.namaJenis).toList(),
                icon: Icons.sports,
                onChanged: (value) {
                  setState(() {
                    _selectedJenisOlahraga = value;
                  });
                },
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Row untuk Harga dan Kapasitas
        Row(
          children: [
            Expanded(
              child: _buildModernTextField(
                controller: _hargaController,
                label: 'Harga Per Jam',
                hint: '0',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixText: 'Rp ',
                isRequired: true,
                validator: (value) => Validators.validatePrice(value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernTextField(
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
            ),
          ],
        ),
        const SizedBox(height: 32),

        _buildSectionTitle('Lokasi', Icons.location_on),
        const SizedBox(height: 24),

        // Alamat
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

        // Row untuk Kecamatan dan Kabupaten
        Row(
          children: [
            Expanded(
              child: _buildModernTextField(
                controller: _kecamatanController,
                label: 'Kecamatan',
                hint: 'Nama kecamatan',
                icon: Icons.location_city,
                isRequired: true,
                validator: (value) => Validators.validateRequired(value, 'Kecamatan'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernTextField(
                controller: _kabupatenController,
                label: 'Kabupaten/Kota',
                hint: 'Nama kabupaten/kota',
                icon: Icons.location_city,
                isRequired: true,
                validator: (value) => Validators.validateRequired(value, 'Kabupaten/Kota'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Provinsi
        _buildModernTextField(
          controller: _provinsiController,
          label: 'Provinsi',
          hint: 'Nama provinsi',
          icon: Icons.map,
          isRequired: true,
          validator: (value) => Validators.validateRequired(value, 'Provinsi'),
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

        _buildSectionTitle('Media & Fasilitas', Icons.photo_library),
        const SizedBox(height: 24),

        // Gambar Lapangan
        _buildModernImageUpload(),
        const SizedBox(height: 24),

        // Fasilitas Tambahan
        _buildModernFasilitas(),
        const SizedBox(height: 24),

        // Status Lapangan
        _buildModernStatusToggle(),
        const SizedBox(height: 32),

        // Lane Section
        _buildModernLaneSection(),
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

  Widget _buildModernDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
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
        DropdownButtonFormField<String>(
          value: value,
          style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(icon, color: const Color(0xFF0088E8), size: 20),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label tidak boleh kosong';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildModernImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gambar Lapangan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
          ),
          child: InkWell(
            onTap: () {
              _showErrorSnackBar('Image picker akan diimplementasi nanti');
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: Color(0xFF0088E8),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tap untuk upload gambar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Maksimal 5 gambar, ukuran maks 5MB',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
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
                      ? 'Aktif - Lapangan dapat dipesan'
                      : 'Tidak Aktif - Lapangan tidak dapat dipesan',
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

  Widget _buildModernLaneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Lane Lapangan', Icons.view_module),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _showLaneForm = !_showLaneForm;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showLaneForm ? Icons.remove : Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _showLaneForm ? 'Tutup' : 'Tambah Lane',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Form Tambah Lane
        if (_showLaneForm) _buildModernLaneForm(),

        // List Lane yang sudah ditambahkan
        if (_lanes.isNotEmpty) _buildModernLaneList(),
      ],
    );
  }

  Widget _buildModernLaneForm() {
    final laneFormKey = GlobalKey<FormState>();
    final namaLaneController = TextEditingController();
    final deskripsiLaneController = TextEditingController();
    final kapasitasLaneController = TextEditingController();
    final hargaLaneController = TextEditingController();
    String? selectedJenisOlahragaLane;
    bool statusLane = true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0088E8).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088E8).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: laneFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.add_box,
                    color: Color(0xFF0088E8),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Form Tambah Lane',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0088E8),
                  ),
                ),
                const Spacer(),
                if (_jenisOlahragaList.isEmpty)
                  TextButton.icon(
                    onPressed: _refreshJenisOlahraga,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Refresh'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0088E8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Nama Lane
            TextFormField(
              controller: namaLaneController,
              style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
              decoration: const InputDecoration(
                labelText: 'Nama Lane *',
                hintText: 'Contoh: Lane A, Court 1',
                prefixIcon: Icon(Icons.label, color: Color(0xFF0088E8), size: 20),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama lane tidak boleh kosong';
                }
                if (_isDuplicateLaneName(value.trim())) {
                  return 'Nama lane sudah digunakan';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Jenis Olahraga Lane
            DropdownButtonFormField<String>(
              value: selectedJenisOlahragaLane,
              style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
              decoration: const InputDecoration(
                labelText: 'Jenis Olahraga *',
                prefixIcon: Icon(Icons.sports, color: Color(0xFF0088E8), size: 20),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              items: _jenisOlahragaList.isEmpty
                  ? [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Memuat data...'),
                      )
                    ]
                  : _jenisOlahragaList.map((jenisOlahraga) {
                      return DropdownMenuItem<String>(
                        value: jenisOlahraga.namaJenis,
                        child: Text(jenisOlahraga.namaJenis),
                      );
                    }).toList(),
              onChanged: _jenisOlahragaList.isEmpty
                  ? null
                  : (value) {
                      selectedJenisOlahragaLane = value;
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih jenis olahraga';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Deskripsi Lane
            TextFormField(
              controller: deskripsiLaneController,
              maxLines: 2,
              style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
              decoration: const InputDecoration(
                labelText: 'Deskripsi Lane',
                hintText: 'Deskripsi tambahan (opsional)',
                prefixIcon: Icon(Icons.description, color: Color(0xFF0088E8), size: 20),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Row untuk Kapasitas dan Harga
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: kapasitasLaneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
                    decoration: const InputDecoration(
                      labelText: 'Kapasitas *',
                      hintText: '0',
                      suffixText: 'orang',
                      prefixIcon: Icon(Icons.people, color: Color(0xFF0088E8), size: 20),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
                      ),
                    ),
                    validator: (value) => Validators.validateCapacity(value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: hargaLaneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
                    decoration: const InputDecoration(
                      labelText: 'Harga/Jam *',
                      hintText: '0',
                      prefixText: 'Rp ',
                      prefixIcon: Icon(Icons.attach_money, color: Color(0xFF0088E8), size: 20),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0088E8), width: 2),
                      ),
                    ),
                                        validator: (value) => Validators.validatePrice(value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status Lane
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    statusLane ? Icons.check_circle : Icons.cancel,
                    color: statusLane ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Lane',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          statusLane ? 'Aktif - Lane dapat dipesan' : 'Tidak Aktif - Lane tidak dapat dipesan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: statusLane,
                    onChanged: (value) {
                      setState(() {
                        statusLane = value;
                      });
                    },
                    activeColor: const Color(0xFF0088E8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showLaneForm = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: const Center(
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 44,
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
                          if (laneFormKey.currentState!.validate() &&
                              selectedJenisOlahragaLane != null) {
                            
                            // Validasi tambahan untuk duplikasi nama
                            if (_isDuplicateLaneName(namaLaneController.text.trim())) {
                              _showErrorSnackBar('Nama lane "${namaLaneController.text}" sudah digunakan');
                              return;
                            }

                            setState(() {
                              _lanes.add(
                                LaneData(
                                  namaLane: namaLaneController.text.trim(),
                                  jenisOlahraga: selectedJenisOlahragaLane!,
                                  deskripsi: deskripsiLaneController.text.trim(),
                                  kapasitas: int.parse(kapasitasLaneController.text),
                                  hargaPerJam: int.parse(hargaLaneController.text),
                                  status: statusLane,
                                ),
                              );
                              _showLaneForm = false;
                            });

                            _showSuccessSnackBar('Lane "${namaLaneController.text}" berhasil ditambahkan');
                          } else if (selectedJenisOlahragaLane == null) {
                            _showErrorSnackBar('Pilih jenis olahraga untuk lane');
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: const Center(
                          child: Text(
                            'Tambah Lane',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernLaneList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Lane (${_lanes.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            if (_lanes.isNotEmpty)
              Text(
                'Total: ${_lanes.length} lane',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _lanes.length,
          itemBuilder: (context, index) {
            final lane = _lanes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: lane.status ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                lane.status ? 'Aktif' : 'Tidak Aktif',
                                style: TextStyle(
                                  color: lane.status ? Colors.green : Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lane.namaLane,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.sports, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(lane.jenisOlahraga, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(width: 12),
                            Icon(Icons.people, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text('${lane.kapasitas} orang', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${_formatCurrency(lane.hargaPerJam)}/jam',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0088E8),
                          ),
                        ),
                        if (lane.deskripsi.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            lane.deskripsi,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088E8).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFF0088E8), size: 20),
                          onPressed: () => _showEditLaneDialog(index),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          onPressed: () => _showDeleteLaneDialog(index),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModernSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
          onTap: _isLoading ? null : () {
            if (_validateMainForm()) {
              _showModernSubmitDialog();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
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

// Data class untuk Lane
class LaneData {
  final String namaLane;
  final String jenisOlahraga;
  final String deskripsi;
  final int kapasitas;
  final int hargaPerJam;
  final bool status;

  LaneData({
    required this.namaLane,
    required this.jenisOlahraga,
    required this.deskripsi,
    required this.kapasitas,
    required this.hargaPerJam,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama_lane': namaLane,
      'jenis_olahraga': jenisOlahraga,
      'deskripsi': deskripsi,
      'kapasitas': kapasitas,
      'harga_per_jam': hargaPerJam,
      'status': status,
    };
  }

  // Method untuk membuat copy dengan perubahan
  LaneData copyWith({
    String? namaLane,
    String? jenisOlahraga,
    String? deskripsi,
    int? kapasitas,
    int? hargaPerJam,
    bool? status,
  }) {
    return LaneData(
      namaLane: namaLane ?? this.namaLane,
      jenisOlahraga: jenisOlahraga ?? this.jenisOlahraga,
      deskripsi: deskripsi ?? this.deskripsi,
      kapasitas: kapasitas ?? this.kapasitas,
      hargaPerJam: hargaPerJam ?? this.hargaPerJam,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'LaneData(namaLane: $namaLane, jenisOlahraga: $jenisOlahraga, kapasitas: $kapasitas, hargaPerJam: $hargaPerJam, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaneData &&
        other.namaLane == namaLane &&
        other.jenisOlahraga == jenisOlahraga &&
        other.deskripsi == deskripsi &&
        other.kapasitas == kapasitas &&
        other.hargaPerJam == hargaPerJam &&
        other.status == status;
  }

  @override
  int get hashCode {
    return namaLane.hashCode ^
        jenisOlahraga.hashCode ^
        deskripsi.hashCode ^
        kapasitas.hashCode ^
        hargaPerJam.hashCode ^
        status.hashCode;
  }
}




