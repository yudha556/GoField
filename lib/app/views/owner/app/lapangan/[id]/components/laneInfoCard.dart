  import 'package:flutter/material.dart';
  import 'package:gofield/core/models/lapanganDetail_model.dart';
  import 'package:gofield/core/models/jenisOlahraga_model.dart';

  class LaneInfoCard extends StatelessWidget {
    final LaneDetailModel lane;
    final VoidCallback? onEdit;
    final VoidCallback? onDelete;
    final Function(bool)? onToggleStatus;

    const LaneInfoCard({
      super.key,
      required this.lane,
      this.onEdit,
      this.onDelete,
      this.onToggleStatus,
    });

    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status dan Actions
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: lane.aktif
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: lane.aktif ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        lane.aktif ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: lane.aktif ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lane.aktif ? 'Aktif' : 'Tidak Aktif',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: lane.aktif ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Action buttons
                Row(
                  children: [
                    if (onEdit != null)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088E8).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                                                icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF0088E8),
                            size: 20,
                          ),
                          onPressed: onEdit,
                          tooltip: 'Edit Lane',
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (onToggleStatus != null)
                      Container(
                        decoration: BoxDecoration(
                          color: lane.aktif
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            lane.aktif ? Icons.pause : Icons.play_arrow,
                            color: lane.aktif ? Colors.orange : Colors.green,
                            size: 20,
                          ),
                          onPressed: () => onToggleStatus!(!lane.aktif),
                          tooltip: lane.aktif ? 'Nonaktifkan' : 'Aktifkan',
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (onDelete != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: onDelete,
                          tooltip: 'Hapus Lane',
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Info Dasar
            _buildInfoSection(),
            const SizedBox(height: 20),

            // Gambar Section (Placeholder)
            _buildGambarSection(),
            const SizedBox(height: 20),

            // Jadwal Section (Placeholder)
            _buildJadwalSection(),
          ],
        ),
      );
    }

    Widget _buildInfoSection() {
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
            const Text(
              'Informasi Lane',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),

            // Jenis Olahraga
            _buildInfoRow(
              Icons.sports,
              'Jenis Olahraga',
              lane.jenisOlahragaNama ?? 'Tidak diketahui',
            ),
            const SizedBox(height: 12),

            // Kapasitas
            _buildInfoRow(
              Icons.people,
              'Kapasitas',
              '${lane.kapasitas} orang',
            ),
            const SizedBox(height: 12),

            // Harga
            _buildInfoRow(
              Icons.attach_money,
              'Harga per Jam',
              'Rp ${_formatCurrency(lane.hargaPerJam)}',
            ),
            const SizedBox(height: 12),

            // Deskripsi
            if (lane.deskripsi.isNotEmpty)
              _buildInfoRow(
                Icons.description,
                'Deskripsi',
                lane.deskripsi,
              ),
          ],
        ),
      );
    }

    Widget _buildInfoRow(IconData icon, String label, String value) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0088E8), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget _buildGambarSection() {
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
                const Icon(Icons.photo_library, color: Color(0xFF0088E8), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Galeri Lane',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 16),
                    onPressed: () {
                      // TODO: Implement add image
                    },
                    tooltip: 'Tambah Gambar',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Image placeholder
            if (lane.urlGambar != null && lane.urlGambar!.isNotEmpty)
              _buildImageCarousel()
            else
              _buildEmptyImageState(),
          ],
        ),
      );
    }

    Widget _buildImageCarousel() {
      return Container(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lane.urlGambar!.length,
          itemBuilder: (context, index) {
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(lane.urlGambar![index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    }

    Widget _buildEmptyImageState() {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera, size: 32, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Belum ada gambar',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap + untuk menambah',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildJadwalSection() {
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
                const Icon(Icons.schedule, color: Color(0xFF0088E8), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Jadwal Operasional',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                    onPressed: () {
                      // TODO: Implement edit schedule
                    },
                    tooltip: 'Atur Jadwal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Schedule placeholder
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.calendar_today, size: 32, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Jadwal belum diatur',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap edit untuk mengatur jadwal operasional',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    String _formatCurrency(double amount) {
      return amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
  }

