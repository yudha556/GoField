import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/core/components/buttons/button.dart';
import 'package:gofield/core/router/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0088E8),
        statusBarIconBrightness: Brightness.dark, 
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(
        showNavBar: true,
        child: SafeArea(
          child: ProfileContent(),
        ),
      ),
    );
  }
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _isCustomerServiceExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background gradient
              Container(
                height:180,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Turki Alfaend Damanik',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: -50,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Kiri - Total Lapangan
                      const Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Lapangan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '20',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Garis vertikal
                      Container(width: 1, height: 50, color: Colors.grey[300]),

                      // Kanan - Total Point
                      const Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Point',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '150',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 90),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jadwal Mendatang',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),

                // Container untuk jadwal
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.date_range_outlined,
                                  size: 20,
                                  weight: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Glagah Futsal",
                                  style: TextStyle(
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "15 Juni 2025, 19:00 - 20:00",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.map_outlined, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  "Jalan Nitikan, Yogyakarta",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Gunakan LinkButton yang sudah ada
                      LinkButton(
                        text: 'Detail',
                        size: ButtonSize.small,
                        onPressed: () {
                          print('Detail Button pressed');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          // pemisah
          Container(
            width: double.maxFinite,
            height: 6,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),

          // ;anjut buttonya
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preferensi Pengguna',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 3),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/payment-methods');
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.wallet_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Metode Pembayaran',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.go(AppRoutes.usertransaksiPage);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.event_note_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Riwayat Reservasi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/payment-methods');
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.heart_broken, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Lapangan favorit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // pemisah
          Container(
            width: double.maxFinite,
            height: 6,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),

          // bantuan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 3),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/payment-methods');
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.contact_support_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'FAQ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCustomerServiceExpanded = !_isCustomerServiceExpanded;
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.support_agent_outlined, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Customer Service',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              // Animated Icon Rotation
                              AnimatedRotation(
                                turns: _isCustomerServiceExpanded ? 0.25 : 0.0, 
                                duration: Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Animated Dropdown Content
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: _isCustomerServiceExpanded ? null : 0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _isCustomerServiceExpanded ? 1.0 : 0.0,
                        child: _isCustomerServiceExpanded
                          ? Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Column(
                                children: [
                                  // WhatsApp Option
                                  GestureDetector(
                                    onTap: () {
                                      print('WhatsApp tapped');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      child: Row(
                                        children: [
                                          Icon(Icons.chat, size: 18, color: Colors.green),
                                          SizedBox(width: 12),
                                          Text(
                                            'WhatsApp',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Email Option
                                  GestureDetector(
                                    onTap: () {
                                      print('Email tapped');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      child: Row(
                                        children: [
                                          Icon(Icons.email_outlined, size: 18, color: Colors.blue),
                                          SizedBox(width: 12),
                                          Text(
                                            'Email',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/payment-methods');
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Laporkan Masalah',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 80),
        ],
      ),
    );
  }
}
