import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/components/buttons/button.dart';

class IdPeninjauan extends StatelessWidget {
  const IdPeninjauan({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final data = {
      'lapangan': 'Futsal Gemilang',
      'pemilik': 'Joko Supardi',
      'noHp': '082112345678',
      'alamat': 'Jl. Merdeka No. 88',
      'deskripsi': 'Lapangan futsal berstandar nasional',
      'fasilitas': 'WC, Mushola, Warung',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomBackButton(
              title: 'Detail Permintaan',
              backgroundColor: Colors.white,
              onPressed: () {
                context.go(AppRoutes.adminPeninjauanPage);
              },
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Nama Lapangan', data['lapangan']!),
                    _buildDetailRow('Nama Pemilik', data['pemilik']!),
                    _buildDetailRow('No. HP', data['noHp']!),
                    _buildDetailRow('Alamat', data['alamat']!),
                    _buildDetailRow('Deskripsi', data['deskripsi']!),
                    _buildDetailRow('Fasilitas', data['fasilitas']!),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CancelButton(
                          text: 'Tolak',
                          size: ButtonSize.medium,
                          // backgroundColor: Colors.red,
                          onPressed: () {
                            // TODO: Update status jadi ditolak
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Permintaan ditolak')),
                            );
                            context.go(AppRoutes.adminPeninjauanPage);
                          },
                        ),
                        PrimaryButton(
                          text: 'ACC',
                          size: ButtonSize.medium,
                          onPressed: () {
                            // TODO: Update status jadi disetujui
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Permintaan disetujui')),
                            );
                            context.go(AppRoutes.adminPeninjauanPage);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }
}
