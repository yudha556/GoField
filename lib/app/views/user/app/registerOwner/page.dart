import 'package:flutter/material.dart';
import 'package:gofield/core/components/components.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';

class OwnerRegister extends StatelessWidget {
  const OwnerRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            SafeArea(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 170,
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
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Daftar Sebagai Pemilik Lapangan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: CustomBackButton(
                      backgroundColor: Colors.transparent,
                      iconColor: Colors.white,
                      onPressed: () {
                        context.go(AppRoutes.userprofilePage);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),

            // TOMBOL DAFTAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: PrimaryButton(
                text: 'Daftar Sebagai Pemilik Lapangan',
                size: ButtonSize.medium,
                onPressed: () {
                  context.go(AppRoutes.OwnerRegisterForm);
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
