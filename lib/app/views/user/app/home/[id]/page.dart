import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/services/lapanganService.dart';
import 'package:gofield/app/views/user/app/home/[id]/components/bottomBar.dart';

class DetailLapangan extends StatefulWidget {
  const DetailLapangan({super.key});

  @override
  State<DetailLapangan> createState() => _DetailLapanganState();
}

class _DetailLapanganState extends State<DetailLapangan> {
  LapanganDetailModel? _lapangan;
  bool _isLoading = true;
  String? _error;
  String? _lapanganId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  void _initializeData() {
    final uri = GoRouterState.of(context).uri;
    _lapanganId = uri.pathSegments.last;

    if (_lapanganId != null && _lapanganId!.isNotEmpty) {
      _loadLapanganDetail();
    } else {
      setState(() {
        _error = 'ID Lapangan tidak valid';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLapanganDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final lapangan = await LapanganService.getDetailLapangan(_lapanganId!);

      if (mounted) {
        setState(() {
          _lapangan = lapangan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Method untuk mendapatkan harga terendah dari lanes
  double? _getLowestPrice() {
    if (_lapangan?.lanes == null || _lapangan!.lanes!.isEmpty) {
      return null;
    }

    double? lowestPrice;
    for (var lane in _lapangan!.lanes!) {
      if (lane.hargaPerJam != null && lane.aktif) {
        if (lowestPrice == null || lane.hargaPerJam! < lowestPrice) {
          lowestPrice = lane.hargaPerJam!;
        }
      }
    }
    return lowestPrice;
  }

  // Method untuk format currency
  String _formatCurrency(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showSnackBar(String message, {bool isError = false}) { 
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBooking() {
    _showSnackBar('Fitur booking akan segera tersedia');
  }

  void _handleChat() {
    _showSnackBar('Fitur chat akan segera tersedia');
  }

  void _handleOpenMap() {
    if (_lapangan?.latitude != null && _lapangan?.longitude != null) {
      _showSnackBar('Fitur buka peta akan segera tersedia');
    } else {
      _showSnackBar('Koordinat tidak tersedia', isError: true);
    }
  }

  bool get _isLapanganTersedia {
    if (_lapangan?.status == null) return false;
    final status = _lapangan!.status.toString().trim();
    return status == 'buka';
  }

  String get _getStatusText {
    if (_lapangan?.status == null) return 'Status Tidak Diketahui';
    
    final status = _lapangan!.status.toString().trim();
    
    switch (status) {
      case 'buka':
        return 'buka';
      case 'tutup':
        return 'Tutup';
      case 'maintenance':
        return 'Sedang Maintenance';
      default:
        return 'Status: $status';
    }
  }

  Color get _getStatusColor {
    if (_lapangan?.status == null) return Colors.grey;
    
    final status = _lapangan!.status.toString().trim();
    
    switch (status) {
      case 'buka':
        return Colors.green;
      case 'Tutup':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData get _getStatusIcon {
    if (_lapangan?.status == null) return Icons.help_outline;
    
    final status = _lapangan!.status.toString().trim();
    
    switch (status) {
      case 'buka':
        return Icons.check_circle;
      case 'tutup':
        return Icons.cancel;
      case 'maintenance':
        return Icons.schedule;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[50], body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_lapangan == null) {
      return _buildNotFoundState();
    }

    return _buildContent();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat detail lapangan...',
            style: TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Terjadi kesalahan yang tidak diketahui',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.userDashboard),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembali'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _loadLapanganDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088E8),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lapangan Tidak Ditemukan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lapangan yang Anda cari tidak ditemukan atau mungkin tidak tersedia.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.userDashboard),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088E8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final lowestPrice = _getLowestPrice();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0088E8),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.go(AppRoutes.userDashboard),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _lapangan!.namaLapangan,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.sports_soccer,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadLapanganDetail,
                tooltip: 'Refresh',
              ),
            ],
          ),

          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              // Price Info Card
              if (lowestPrice != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0088E8).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Harga Mulai Dari',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${_formatCurrency(lowestPrice)}/jam',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Harga terendah dari semua lane',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Info Lapangan Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Lapangan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    if (_lapangan!.deskripsiLapangan.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.description,
                            size: 20,
                            color: Color(0xFF0088E8),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Deskripsi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _lapangan!.deskripsiLapangan,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Kapasitas
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 20,
                          color: Color(0xFF0088E8),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Kapasitas: ${_lapangan!.kapasitas} orang',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          _getStatusIcon,
                          size: 20,
                          color: _getStatusColor,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Status: ${_getStatusText}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Lokasi Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lokasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _handleOpenMap,
                          icon: const Icon(Icons.map, size: 16),
                          label: const Text('Buka Peta'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0088E8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Color(0xFF0088E8),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _lapangan!.alamat,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_lapangan!.kecamatan ?? ''}, ${_lapangan!.kabupaten ?? ''}, ${_lapangan!.provinsi ?? ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Lane/Court List
              if (_lapangan!.lanes != null && _lapangan!.lanes!.isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Lane (${_lapangan!.lanes!.where((lane) => lane.aktif).length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...(_lapangan!.lanes!.where((lane) => lane.aktif).map((lane) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0088E8).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.sports_soccer,
                                  size: 20,
                                  color: Color(0xFF0088E8),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lane.namaLane,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${lane.kapasitas} orang • ${lane.jenisOlahragaNama ?? 'Olahraga'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (lane.deskripsi.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        lane.deskripsi,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (lane.hargaPerJam != null)
                                    Text(
                                      _formatCurrency(lane.hargaPerJam!),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0088E8),
                                      ),
                                    ),
                                  const Text(
                                    'per jam',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 100), 
            ]),
          ),
        ],
      ),
      bottomNavigationBar: DetailLapanganBottomBar(
        isAvailable: _isLapanganTersedia,
        onChatPressed: _handleChat,
        onBookingPressed: _handleBooking,
        lowestPrice: lowestPrice,
        status: _lapangan!.status, 
      ),
    );
  }
}
