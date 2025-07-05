import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/models/lane_model.dart';
import 'package:gofield/core/models/jenisOlahraga_model.dart';
import 'package:gofield/core/services/laneService.dart';
import 'package:gofield/core/services/jenisOlahragaService.dart';
import 'package:gofield/core/utils/validators.dart';

class TambahLane extends StatefulWidget {
  final String? lapanganId;
  final String? namaLapangan;

  const TambahLane({super.key, this.lapanganId, this.namaLapangan});

  @override
  State<TambahLane> createState() => _TambahLaneState();
}

class _TambahLaneState extends State<TambahLane> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaLaneController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _kapasitasController = TextEditingController();
  final _hargaController = TextEditingController();

  // Form values
  String? _selectedJenisOlahraga;
  bool _statusLane = true;
  bool _isLoading = false;
  bool _showLaneForm = false;

  // Data
  List<JenisOlahragaModel> _jenisOlahragaList = [];
  List<LaneData> _lanes = [];

  // Lapangan info
  bool _isInitialized = false;
  String? _lapanganId;
  String? _namaLapangan;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _initializeData();
      _loadJenisOlahraga();
      _isInitialized = true;
    }
  }

  void _initializeData() {
    final uri = GoRouterState.of(context).uri;
    _lapanganId = uri.queryParameters['lapanganId'];
    _namaLapangan = uri.queryParameters['namaLapangan'];

    if (_namaLapangan != null) {
      _namaLapangan = Uri.decodeComponent(_namaLapangan!);
    }
  }

  @override
  void dispose() {
    _namaLaneController.dispose();
    _deskripsiController.dispose();
    _kapasitasController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _loadJenisOlahraga() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final jenisOlahraga =
          await JenisOlahragaService.ambilSemuaJenisOlahraga();

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

  bool _isDuplicateLaneName(String namaLane) {
    return _lanes.any(
      (lane) => lane.namaLane.toLowerCase() == namaLane.toLowerCase(),
    );
  }

  void _resetLaneForm() {
    _namaLaneController.clear();
    _deskripsiController.clear();
    _kapasitasController.clear();
    _hargaController.clear();
    setState(() {
      _selectedJenisOlahraga = null;
      _statusLane = true;
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _lanes.removeAt(index);
                });
                Navigator.of(context).pop();
                _showSuccessSnackBar('Lane berhasil dihapus');
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
                'Apakah Anda yakin ingin menyimpan semua lane ini?',
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
                      'Lapangan: $_namaLapangan',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jumlah Lane: ${_lanes.length}',
                      style: TextStyle(color: Colors.grey[600]),
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
                      'Simpan Semua Lane',
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
                'Lane Berhasil Disimpan!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${_lanes.length} lane berhasil ditambahkan ke lapangan "$_namaLapangan".',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lapangan Anda siap untuk menerima reservasi!',
                        style: TextStyle(
                          color: Colors.green[700],
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kembali ke Daftar Lapangan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
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
                'Gagal Menyimpan Lane',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    if (_isLoading || _lanes.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Show loading dialog
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF0088E8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Menyimpan ${_lanes.length} lane...'),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      List<LaneModel> laneModels = [];

      for (var laneData in _lanes) {
        final laneModel = LaneModel(
          idLapangan: _lapanganId!,
          idOlahraga: laneData.jenisOlahragaId,
          namaLane: laneData.namaLane,
          deskripsi: laneData.deskripsi.isEmpty ? '' : laneData.deskripsi,
          kapasitas: laneData.kapasitas,
          hargaPerJam: laneData.hargaPerJam,
          aktif: laneData.status,
        );

        laneModels.add(laneModel);
      }

      print('Saving ${laneModels.length} lanes to lapangan $_lapanganId...');
      final success = await LaneService.tambahMultipleLanes(laneModels);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (success) {
        print('Lanes saved successfully!');
        _showSuccessDialog();
      } else {
        throw Exception('Gagal menyimpan lane ke database');
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      print('Error saving lanes: $e');
      _showErrorDialog('Gagal menyimpan lane: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_lapanganId == null || _namaLapangan == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Data lapangan tidak ditemukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Silakan kembali dan pilih lapangan terlebih dahulu.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

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
                              'Tambah Lane',
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
                      // Info lapangan
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sports_soccer,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Menambahkan lane untuk:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    _namaLapangan!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                  child: _isLoading && _jenisOlahragaList.isEmpty
                      ? _buildLoadingWidget()
                      : _buildFormContent(),
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

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
          ),
          SizedBox(height: 16),
          Text('Memuat data...'),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Lane Lapangan', Icons.view_module),
        const SizedBox(height: 24),

        // Info summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0088E8).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0088E8).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF0088E8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambahkan Lane',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0088E8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Setiap lane dapat memiliki harga dan jenis olahraga yang berbeda.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Add Lane Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Lane (${_lanes.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
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
                    if (_showLaneForm) {
                      _resetLaneForm();
                    }
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
        if (_showLaneForm) _buildLaneForm(),

        // List Lane yang sudah ditambahkan
        if (_lanes.isNotEmpty) _buildLaneList(),

        // Submit Button
        if (_lanes.isNotEmpty) ...[
          const SizedBox(height: 32),
          _buildSubmitButton(),
        ],
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

  Widget _buildLaneForm() {
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
        key: _formKey,
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
              ],
            ),
            const SizedBox(height: 20),

            // Nama Lane
            _buildModernTextField(
              controller: _namaLaneController,
              label: 'Nama Lane',
              hint: 'Contoh: Lane A, Court 1',
              icon: Icons.label,
              isRequired: true,
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

            // Jenis Olahraga
            _buildModernDropdown(
              label: 'Jenis Olahraga',
              value: _selectedJenisOlahraga,
              items: _jenisOlahragaList
                  .map((j) => DropdownItem(j.id, j.namaJenis))
                  .toList(),
              icon: Icons.sports,
              onChanged: (value) {
                setState(() {
                  _selectedJenisOlahraga = value;
                });
              },
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Deskripsi
            _buildModernTextField(
              controller: _deskripsiController,
              label: 'Deskripsi Lane',
              hint: 'Deskripsi tambahan (opsional)',
              icon: Icons.description,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Row untuk Kapasitas dan Harga
            Row(
              children: [
                Expanded(
                  child: _buildModernTextField(
                    controller: _kapasitasController,
                    label: 'Kapasitas',
                    hint: '0',
                    icon: Icons.people,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffixText: 'orang',
                    isRequired: true,
                    validator: (value) => Validators.validateCapacity(value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernTextField(
                    controller: _hargaController,
                    label: 'Harga/Jam',
                    hint: '0',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixText: 'Rp ',
                    isRequired: true,
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
                    _statusLane ? Icons.check_circle : Icons.cancel,
                    color: _statusLane ? Colors.green : Colors.red,
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
                          _statusLane
                              ? 'Aktif - Lane dapat dipesan'
                              : 'Tidak Aktif - Lane tidak dapat dipesan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _statusLane,
                    onChanged: (value) {
                      setState(() {
                        _statusLane = value;
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
                          _resetLaneForm();
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
                          if (_formKey.currentState!.validate() &&
                              _selectedJenisOlahraga != null) {
                            // Validasi tambahan untuk duplikasi nama
                            if (_isDuplicateLaneName(
                              _namaLaneController.text.trim(),
                            )) {
                              _showErrorSnackBar(
                                'Nama lane "${_namaLaneController.text}" sudah digunakan',
                              );
                              return;
                            }

                            final jenisOlahraga = _jenisOlahragaList.firstWhere(
                              (j) => j.id == _selectedJenisOlahraga,
                            );

                            setState(() {
                              _lanes.add(
                                LaneData(
                                  namaLane: _namaLaneController.text.trim(),
                                  jenisOlahragaId: _selectedJenisOlahraga!,
                                  jenisOlahragaNama: jenisOlahraga.namaJenis,
                                  deskripsi: _deskripsiController.text.trim(),
                                  kapasitas: int.parse(
                                    _kapasitasController.text,
                                  ),
                                  hargaPerJam: double.parse(
                                    _hargaController.text,
                                  ),
                                  status: _statusLane,
                                ),
                              );
                              _showLaneForm = false;
                            });

                            _resetLaneForm();
                            _showSuccessSnackBar(
                              'Lane "${_namaLaneController.text}" berhasil ditambahkan',
                            );
                          } else if (_selectedJenisOlahraga == null) {
                            _showErrorSnackBar(
                              'Pilih jenis olahraga untuk lane',
                            );
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
    required List<DropdownItem> items,
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
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0088E8), size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0088E8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
          items: items.map((DropdownItem item) {
            final isSelected = item.value == value;
            return DropdownMenuItem<String>(
              value: item.value,
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? const Color(0xFF0088E8)
                      : const Color(0xFF2D3748),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
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

  Widget _buildLaneList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: lane.status
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                lane.status ? 'Aktif' : 'Tidak Aktif',
                                style: TextStyle(
                                  color: lane.status
                                      ? Colors.green
                                      : Colors.red,
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
                            Icon(
                              Icons.sports,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lane.jenisOlahragaNama,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.people,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${lane.kapasitas} orang',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
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
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
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

  Widget _buildSubmitButton() {
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
                  HapticFeedback.lightImpact();
                  if (_lanes.isEmpty) {
                    _showErrorSnackBar('Tambahkan minimal satu lane');
                    return;
                  }
                  _showSubmitDialog();
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan ${_lanes.length} Lane',
                        style: const TextStyle(
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
  final String jenisOlahragaId;
  final String jenisOlahragaNama;
  final String deskripsi;
  final int kapasitas;
  final double hargaPerJam;
  final bool status;

  LaneData({
    required this.namaLane,
    required this.jenisOlahragaId,
    required this.jenisOlahragaNama,
    required this.deskripsi,
    required this.kapasitas,
    required this.hargaPerJam,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama_lane': namaLane,
      'id_olahraga': jenisOlahragaId,
      'jenis_olahraga_nama': jenisOlahragaNama,
      'deskripsi': deskripsi,
      'kapasitas': kapasitas,
      'harga_per_jam': hargaPerJam,
      'aktif': status,
    };
  }

  LaneData copyWith({
    String? namaLane,
    String? jenisOlahragaId,
    String? jenisOlahragaNama,
    String? deskripsi,
    int? kapasitas,
    double? hargaPerJam,
    bool? status,
  }) {
    return LaneData(
      namaLane: namaLane ?? this.namaLane,
      jenisOlahragaId: jenisOlahragaId ?? this.jenisOlahragaId,
      jenisOlahragaNama: jenisOlahragaNama ?? this.jenisOlahragaNama,
      deskripsi: deskripsi ?? this.deskripsi,
      kapasitas: kapasitas ?? this.kapasitas,
      hargaPerJam: hargaPerJam ?? this.hargaPerJam,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'LaneData(namaLane: $namaLane, jenisOlahragaId: $jenisOlahragaId, jenisOlahragaNama: $jenisOlahragaNama, kapasitas: $kapasitas, hargaPerJam: $hargaPerJam, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaneData &&
        other.namaLane == namaLane &&
        other.jenisOlahragaId == jenisOlahragaId &&
        other.jenisOlahragaNama == jenisOlahragaNama &&
        other.deskripsi == deskripsi &&
        other.kapasitas == kapasitas &&
        other.hargaPerJam == hargaPerJam &&
        other.status == status;
  }

  @override
  int get hashCode {
    return namaLane.hashCode ^
        jenisOlahragaId.hashCode ^
        jenisOlahragaNama.hashCode ^
        deskripsi.hashCode ^
        kapasitas.hashCode ^
        hargaPerJam.hashCode ^
        status.hashCode;
  }
}

class DropdownItem {
  final String value;
  final String label;

  DropdownItem(this.value, this.label);
}
