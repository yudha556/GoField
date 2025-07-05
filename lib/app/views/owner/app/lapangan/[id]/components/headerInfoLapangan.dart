import 'package:flutter/material.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';
import 'package:gofield/core/models/lapangan_model.dart';
import 'package:gofield/core/constants/app_constans.dart';

class HeaderInfoLapangan extends StatelessWidget {
  final LapanganDetailModel lapangan;
  final VoidCallback? onEdit;

  const HeaderInfoLapangan({super.key, required this.lapangan, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          // Header dengan nama dan status
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lapangan.namaLapangan,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            lapangan.status,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(lapangan.status),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(lapangan.status),
                              size: 16,
                              color: _getStatusColor(lapangan.status),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getStatusText(lapangan.status),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(lapangan.status),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (onEdit != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: onEdit,
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
                // Deskripsi
                if (lapangan.deskripsiLapangan.isNotEmpty) ...[
                  _buildInfoRow(
                    Icons.description,
                    'Deskripsi',
                    lapangan.deskripsiLapangan,
                  ),
                  const SizedBox(height: 16),
                ],

                // Alamat
                _buildInfoRow(Icons.location_on, 'Alamat', _buildFullAddress()),
                const SizedBox(height: 16),

                // Kapasitas
                _buildInfoRow(
                  Icons.people,
                  'Kapasitas Total',
                  '${lapangan.kapasitas} orang',
                ),
                const SizedBox(height: 16),

                // Fasilitas
                if (lapangan.fasilitas != null &&
                    lapangan.fasilitas!.isNotEmpty)
                  _buildFasilitasSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFasilitasSection() {
    final fasilitasList = lapangan.fasilitas!['fasilitas'] as List<dynamic>?;

    if (fasilitasList == null || fasilitasList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0088E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.star, color: Color(0xFF0088E8), size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Fasilitas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: fasilitasList.map((fasilitas) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0088E8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0088E8).withOpacity(0.3),
                ),
              ),
              child: Text(
                fasilitas.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0088E8),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusTersedia:
        return Colors.green;
      case AppConstants.statusTidakTersedia:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.statusTersedia:
        return Icons.check_circle;
      case AppConstants.statusTidakTersedia:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case AppConstants.statusTersedia:
        return 'Buka';
      case AppConstants.statusTidakTersedia:
        return 'Tutup';
      default:
        return 'perbaikan';
    }
  }
}
