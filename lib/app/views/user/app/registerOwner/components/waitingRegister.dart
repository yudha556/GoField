import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/components/components.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0088E8),
                        Color(0xFF4DACEF),
                        Colors.white,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                const Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Daftar Lapangan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 13,
                  left: 4,
                  child: CustomBackButton(
                    backgroundColor: Colors.transparent,
                    iconColor: Colors.white,
                    onPressed: () {
                      context.go(AppRoutes.OwnerRegisterForm);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // ISI TENGAH
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.hourglass_top_rounded,
                      size: 64,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Permintaan pendaftaran lapangan kamu sedang ditinjau oleh admin.\nMohon tunggu beberapa saat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Kembali Ke beranda',
                      size: ButtonSize.medium,
                      onPressed: () {
                        context.go(AppRoutes.userDashboard);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
