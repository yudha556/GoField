import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';
import 'package:gofield/core/services/ownerService/lapanganService.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/app/views/owner/app/lapangan/[id]/components/headerInfoLapangan.dart';
import 'package:gofield/app/views/owner/app/lapangan/[id]/components/location.dart';
import 'package:gofield/app/views/owner/app/lapangan/[id]/components/TabView.dart';

class LapanganId extends StatefulWidget {
  const LapanganId({super.key});

  @override
  State<LapanganId> createState() => _LapanganIdState();
}

class _LapanganIdState extends State<LapanganId> {
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

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleToggleLaneStatus(LaneDetailModel lane, bool newStatus) async {
    try {
      await LapanganService.updateStatusLane(lane.id, newStatus);
      _showSuccessSnackBar(
        'Status lane ${lane.namaLane} berhasil diubah',
      );
      _loadLapanganDetail(); // Refresh data
    } catch (e) {
      _showErrorSnackBar('Gagal mengubah status lane: ${e.toString()}');
    }
  }

  Future<void> _handleDeleteLane(LaneDetailModel lane) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Lane'),
        content: Text('Apakah Anda yakin ingin menghapus lane "${lane.namaLane}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await LapanganService.deleteLane(lane.id);
        _showSuccessSnackBar('Lane ${lane.namaLane} berhasil dihapus');
        _loadLapanganDetail(); // Refresh data
            } catch (e) {
        _showErrorSnackBar('Gagal menghapus lane: ${e.toString()}');
      }
    }
  }

  void _handleEditLane(LaneDetailModel lane) {
    // TODO: Navigate to edit lane page
    _showErrorSnackBar('Fitur edit lane akan segera tersedia');
  }

  void _handleEditLapangan() {
    // TODO: Navigate to edit lapangan page
    _showErrorSnackBar('Fitur edit lapangan akan segera tersedia');
  }

  void _handleOpenMap() {
    if (_lapangan?.latitude != null && _lapangan?.longitude != null) {
      // TODO: Open map with coordinates
      _showErrorSnackBar('Fitur buka peta akan segera tersedia');
    } else {
      _showErrorSnackBar('Koordinat tidak tersedia');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
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
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2D3748),
            ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.ownerLapanganPage),
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
              'Lapangan yang Anda cari tidak ditemukan atau mungkin telah dihapus.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.ownerLapanganPage),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088E8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Kembali ke Daftar Lapangan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFF0088E8),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.go(AppRoutes.ownerLapanganPage),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              _lapangan!.namaLapangan,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
                ),
              ),
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
            
            // Header Info Lapangan
            HeaderInfoLapangan(
              lapangan: _lapangan!,
              onEdit: _handleEditLapangan,
            ),
            
            const SizedBox(height: 16),
            
            // Lokasi Section
            LokasiSection(
              lapangan: _lapangan!,
              onOpenMap: _handleOpenMap,
            ),
            
            const SizedBox(height: 16),
            
            // Lane Tab View
            LaneTabView(
              lanes: _lapangan!.lanes ?? [],
              onEditLane: _handleEditLane,
              onDeleteLane: _handleDeleteLane,
              onToggleStatus: _handleToggleLaneStatus,
            ),
            
            const SizedBox(height: 16),
            
            // - Ulasan Section
            // - Statistik Section
            
            const SizedBox(height: 32),
          ]),
        ),
      ],
    );
  }
}

