import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';

class LokasiSection extends StatelessWidget {
  final LapanganDetailModel lapangan;
  final VoidCallback? onOpenMap;

  const LokasiSection({
    super.key,
    required this.lapangan,
    this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0088E8).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088E8).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFF0088E8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Lokasi Lapangan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                if (onOpenMap != null)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.map, color: Colors.white, size: 20),
                      onPressed: onOpenMap,
                      tooltip: 'Buka di Maps',
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alamat Lengkap
                _buildAddressCard(),
                const SizedBox(height: 16),

                // Koordinat
                if (lapangan.latitude != null && lapangan.longitude != null)
                  _buildCoordinateCard(context),

                // Map Placeholder
                const SizedBox(height: 16),
                _buildMapPlaceholder(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.home, color: Color(0xFF0088E8), size: 20),
              SizedBox(width: 8),
              Text(
                'Alamat Lengkap',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _buildFullAddress(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateCard(BuildContext context) { 
    final coordinates = '${lapangan.latitude}, ${lapangan.longitude}';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gps_fixed, color: Color(0xFF0088E8), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Koordinat',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0088E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF0088E8),
                    size: 16,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: coordinates));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Koordinat berhasil disalin'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  tooltip: 'Salin koordinat',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            coordinates,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/400x200/E2E8F0/718096?text=Map+Preview',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.map,
                        size: 48,
                        color: Color(0xFF0088E8),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pratinjau Peta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lapangan.latitude != null && lapangan.longitude != null
                            ? 'Klik untuk membuka peta'
                            : 'Koordinat tidak tersedia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Clickable overlay
          if (lapangan.latitude != null && lapangan.longitude != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onOpenMap,
                  child: Container(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _buildFullAddress() {
    List<String> addressParts = [lapangan.alamat];
    
    if (lapangan.kecamatan != null && lapangan.kecamatan!.isNotEmpty) {
      addressParts.add(lapangan.kecamatan!);
    }
    if (lapangan.kabupaten != null && lapangan.kabupaten!.isNotEmpty) {
      addressParts.add(lapangan.kabupaten!);
    }
    if (lapangan.provinsi != null && lapangan.provinsi!.isNotEmpty) {
      addressParts.add(lapangan.provinsi!);
    }
    
    return addressParts.join(', ');
  }
}
