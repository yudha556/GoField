import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/app/views/user/components/header.dart';
import 'package:gofield/core/router/app_routes.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainUserScaffold(
      showNavBar: true, 
      child: HomeContent()
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderBar(
              searchHint: 'Cari lapangan olahraga...',
              notificationCount: 3,
              cartItemCount: 2,
              profileImageUrl: null,
              onSearchTap: () {
                print('Search tapped');
              },
              onNotificationTap: () {
                print('Notification tapped');
              },
              onCartTap: () {
                print('Cart tapped');
              },
              onProfileTap: () {
                print('Profile tapped');
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Promo Spesial!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Flexible(
                              child: Text(
                                'Dapatkan diskon 50% untuk booking pertama',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Text(
                      'Kategori Olahraga',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard(context, 'Futsal', Icons.sports_soccer, Colors.green),
                        _buildCategoryCard(context, 'Badminton', Icons.sports_tennis, Colors.blue),
                        _buildCategoryCard(context, 'Basket', Icons.sports_basketball, Colors.orange),
                        _buildCategoryCard(context, 'Voli', Icons.sports_volleyball, Colors.red),
                        _buildCategoryCard(context, 'Tenis', Icons.sports_tennis, Colors.purple),
                      ],
                    ),
                  ),

                  const SizedBox(height: 34),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Text(
                      'Lapangan Populer',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Column(  
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lapangan Populer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Akan segera hadir',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),  
                      ],
                    ),
                  ),

                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Dapatkan Promo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Column(  
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lapangan Populer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Akan segera hadir',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
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
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
           context.go(AppRoutes.userListPage);
        },
        child: Container(
          width: 60,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color,)
            ],
          ),
        ),
      )
    );
  }
}