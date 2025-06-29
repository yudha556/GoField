import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/admin/layout/main_admin_schallfold.dart';
import 'package:gofield/core/router/app_routes.dart';

class PeninjauanPage extends StatelessWidget {
  const PeninjauanPage({super.key});

  @override
    Widget build(BuildContext context) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // IOS
        ),
        child: const MainAdminSchallfold(
          child: SafeArea(child: PeninjauanContent()),
        ),
      );
    }
  }

class PeninjauanContent extends StatelessWidget {
  const PeninjauanContent({super.key});

  @override
  Widget build(BuildContext context) {
    // dummy list
    final requests = [
      {
        'id': 'user-1',
        'nama': 'Joko Supardi',
        'lapangan': 'Futsal Gemilang',
        'alamat': 'Jl. Merdeka No. 88',
      },
      {
        'id': 'user-2',
        'nama': 'Dewi Anggraini',
        'lapangan': 'Basket Kencana',
        'alamat': 'Jl. Pahlawan No. 22',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final item = requests[index];
          return InkWell(
            onTap: () {
              context.go(AppRoutes.adminPeninjauanId);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['lapangan'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Pemilik: ${item['nama']}'),
                    Text('Alamat: ${item['alamat']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}