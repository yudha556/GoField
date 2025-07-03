import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/owner/layout/main_owner_schalfold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/components/avatar/circleAvatar.dart';
import 'package:gofield/core/router/app_routes.dart';

class LapanganOwner extends StatelessWidget {
  const LapanganOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainOwnerSchallfold(
        child: SafeArea(child: LapanganContent()),
      ),
    );
  }
}

class LapanganContent extends StatefulWidget {
  const LapanganContent({super.key});

  @override
  State<LapanganContent> createState() => _LapanganContentState();
}

class _LapanganContentState extends State<LapanganContent> {
  int selectedIndex = 0;

  final List<Map<String, String>> listLapangan = [
    {
      'name': 'Arena Sport Center',
      'location': 'Jakarta Selatan',
      'price': 'Rp 200.000/jam',
      'image': 'assets/images/featured1.jpg',
    },
    {
      'name': 'Elite Futsal Club',
      'location': 'Jakarta Pusat',
      'price': 'Rp 180.000/jam',
      'image': 'assets/images/featured2.jpg',
    },
    {
      'name': 'Premium Court',
      'location': 'Jakarta Utara',
      'price': 'Rp 250.000/jam',
      'image': 'assets/images/featured3.jpg',
    },
    {
      'name': 'Grand Sport Arena',
      'location': 'Jakarta Barat',
      'price': 'Rp 220.000/jam',
      'image': 'assets/images/featured4.jpg',
    },
  ];

  Widget _buildFieldCard(Map<String, String> field, {double? width}) {
    return SizedBox(
      width: width,
      child: GlobalCard(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        elevation: 3,
        isResponsive: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image - Full container dengan aspect ratio 1:1
              AspectRatio(
                aspectRatio: 1.0, // Aspect ratio 1:1
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: const Icon(
                    Icons.sports_soccer,
                    size: 60,
                    color: Colors.grey,
                  ),
                  // Uncomment ini jika ada gambar asli:
                  // child: Image.asset(
                  //   field['image']!,
                  //   fit: BoxFit.cover,
                  //   width: double.infinity,
                  //   height: double.infinity,
                  // ),
                ),
              ),

              // Overlay gradient untuk text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Text overlay di bagian bawah
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Field name
                      Text(
                        field['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Location
                      Text(
                        field['location']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Price
                      Text(
                        field['price']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 25,
                  ),
                  child: Column(
                    children: [
                      // Fixed the Row layout issue here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Wrap CustomSearchBar with Expanded to prevent overflow
                          Expanded(
                            child: CustomSearchBar(
                              hintText: 'Cari lapangan...',
                              onTap: () {},
                              onFilterTap: () {},
                            ),
                          ),
                          const SizedBox(width: 8), // Add spacing between elements
                          CustomCircleAvatar(
                            profileImageUrl: 1,
                            onProfiletap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listLapangan.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0, 
                  ),
                  itemBuilder: (context, index) {
                    return _buildFieldCard(
                      listLapangan[index],
                      width: MediaQuery.of(context).size.width / 2 - 24,
                    );
                  },
                )
              ],
            ),
          ),

          SizedBox(height: 16,),

          Center(
            child: ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.tambahLapangan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088E8),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ), 
              ),
              child: const Text(
                'Tambah Lapangan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ),

          SizedBox(height: 80,)
        ],
      ),
    );
  }
}
