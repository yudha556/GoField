import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/components/search/searchBar.dart';
import 'package:gofield/core/components/card/cards.dart'; // Import card

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(child: SafeArea(child: HomeContent())),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int selectedSportIndex = 0;

  // Data olahraga
  final List<String> sportsList = [
    'Semua',
    'Futsal',
    'Badminton',
    'Basketball',
    'Volleyball',
    'Tennis',
    'Tenis Meja',
    'Golf',
  ];

  // Data untuk horizontal cards - Featured/Recommended
  final List<Map<String, String>> featuredCards = [
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

  // Data untuk grid cards - Popular
  final List<Map<String, String>> popularCards = [
    {
      'name': 'Lapangan Futsal A',
      'location': 'Jakarta Selatan',
      'price': 'Rp 150.000/jam',
      'image': 'assets/images/field1.jpg',
    },
    {
      'name': 'Badminton Court B',
      'location': 'Jakarta Pusat',
      'price': 'Rp 80.000/jam',
      'image': 'assets/images/field2.jpg',
    },
    {
      'name': 'Basketball Arena',
      'location': 'Jakarta Utara',
      'price': 'Rp 200.000/jam',
      'image': 'assets/images/field3.jpg',
    },
    {
      'name': 'Tennis Court',
      'location': 'Jakarta Barat',
      'price': 'Rp 120.000/jam',
      'image': 'assets/images/field4.jpg',
    },
  ];

  // Widget untuk membuat card dengan design yang sama
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
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 300,
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hai, Jean',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black
                                ),
                              ),
                              const SizedBox(height: 0),
                              const Text(
                                'Selamat Datang di Go Field',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                                ),
                              )
                            ],
                          ),
                          Circleavatar(
                            profileImageUrl: 1,
                            onProfiletap: () {},
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search Bar
                      CustomSearchBar(
                        hintText: 'Cari lapangan...',
                        onTap: () {
                          print('Search tapped');
                        },
                        onFilterTap: () {
                          print('Filter tapped');
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Sports Selection Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Yuk, pilih olahragamu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Horizontal Sports List
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sportsList.length,
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              itemBuilder: (context, index) {
                                final sport = sportsList[index];
                                final isSelected = selectedSportIndex == index;
                                
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSportIndex = index;
                                    });
                                    print('Selected: $sport');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                          ? const Color(0xFF0088E8)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        sport,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected 
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          
          // Featured Cards Section - Horizontal Scroll
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), // Kurangi top padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rekomendasi Untuk Anda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12), // Kurangi spacing
                
                // Horizontal Cards
                SizedBox(
                  height: 160, // Fixed height untuk horizontal scroll
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredCards.length,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, index) {
                      final field = featuredCards[index];
                      
                      return Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: _buildFieldCard(field, width: 160), // Width sama dengan height untuk 1:1
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Popular Cards Section - Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lapangan Populer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Grid Cards
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0, // Rasio 1:1 untuk ukuran persegi
                  ),
                  itemCount: popularCards.length,
                  itemBuilder: (context, index) {
                    final field = popularCards[index];
                    return _buildFieldCard(field);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
