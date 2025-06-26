import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/app/home/components/tabView.dart';
import 'package:gofield/app/views/user/components/header.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan SearchOnlyBar
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.userDashboard),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        onTap: () {
                          print('Search tapped');
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari lapangan...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab View
            TabViewHome(
              onTabChanged: (index) {
                // Handle tab changes here
                
              },
            ),

            // Grid Content dengan Custom GridView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.67, // Membuat card lebih panjang (lebar:tinggi = 0.7:1)
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GlobalCard(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image section dengan rasio 1:1
                          AspectRatio(
                            aspectRatio: 1.0, // Rasio 1:1 (persegi)
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/contoh.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        
                          // Content section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product title and favorite
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Glagah Futsal',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.favorite_border, 
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    
                                    // Price
                                    Text(
                                      'Rp 10.000',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    
                                    // Rating and orders
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 16, color: Colors.yellow[600]),
                                        SizedBox(width: 2),
                                        Text(
                                          '5.0',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.circle,
                                          size: 3,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '1rb Pemesanan',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                // Team name and distance (di bagian bawah)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Glagah Team',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.pin_drop_outlined, size: 12),
                                    SizedBox(width: 2),
                                    Text(
                                      '0.1 Km', 
                                      style: TextStyle(
                                        fontSize: 11, 
                                        fontWeight: FontWeight.w400, 
                                        color: Colors.grey
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
