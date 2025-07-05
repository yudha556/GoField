import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/models/lapangan_model.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';
import 'package:gofield/core/services/lapanganService.dart';
import 'package:gofield/app/views/user/app/home/components/tabView.dart';

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
  PenggunaModel? pengguna;
  bool isLoading = true;
  int selectedSportIndex = 0;
  String? selectedJenisOlahragaId;
  
  // Data lapangan
  List<LapanganModel> featuredLapangan = [];
  List<LapanganModel> popularLapangan = [];
  Map<String, double?> lapanganPrices = {};
  bool isLoadingLapangan = false;

  @override
  void initState() {
    super.initState();
    _fetchPengguna();
    _loadLapangan();
  }

  Future<void> _fetchPengguna() async {
    final result = await AuthService.getCurrentPengguna();
    setState(() {
      pengguna = result;
      isLoading = false;
    });
  }

  Future<void> _loadLapangan({String? jenisOlahragaId}) async {
    setState(() {
      isLoadingLapangan = true;
    });

    try {
      final lapanganList = await LapanganService.ambilSemuaLapangan(
        jenisOlahragaId: jenisOlahragaId,
      );

      await _loadPricesForLapangan(lapanganList);

      if (mounted) {
        setState(() {
          featuredLapangan = lapanganList.take(4).toList();
          popularLapangan = lapanganList.skip(4).take(6).toList();
          isLoadingLapangan = false;
        });
      }
    } catch (e) {
      print('Error loading lapangan: $e');
      if (mounted) {
        setState(() {
          isLoadingLapangan = false;
        });
      }
    }
  }

  Future<void> _loadPricesForLapangan(List<LapanganModel> lapanganList) async {
    for (var lapangan in lapanganList) {
      if (lapangan.id != null) {
        try {
          final price = await LapanganService.getLowestPriceByLapangan(lapangan.id!);
          lapanganPrices[lapangan.id!] = price;
        } catch (e) {
          print('Error loading price for lapangan ${lapangan.id}: $e');
          lapanganPrices[lapangan.id!] = null;
        }
      }
    }
  }

  void _onTabChanged(int index, String? jenisOlahragaId) {
    setState(() {
      selectedSportIndex = index;
      selectedJenisOlahragaId = jenisOlahragaId;
    });
    _loadLapangan(jenisOlahragaId: jenisOlahragaId);
  }

  String _getFirstName(String? namaLengkap) {
    if (namaLengkap == null || namaLengkap.isEmpty) {
      return 'Pengguna';
    }
    return namaLengkap.split(' ').first;
  }

  String _formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _navigateToDetail(String lapanganId) {
    context.go('/user/lapangan/$lapanganId');
  }

  Widget _buildFieldCard(LapanganModel field, {double? width}) {
    final lowestPrice = lapanganPrices[field.id];

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
              AspectRatio(
                aspectRatio: 1.0,
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
                ),
              ),

              // Price Badge
              if (lowestPrice != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088E8).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Rp ${_formatCurrency(lowestPrice)}/jam',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Status Badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Tersedia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                      Text(
                        field.namaLapangan,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      
                      Text(
                        '${field.kecamatan ?? ''}, ${field.kabupaten ?? ''}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${field.kapasitas} orang',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (lowestPrice != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Mulai Rp ${_formatCurrency(lowestPrice)}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
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

  Widget _buildLoadingCards({required int count, double? width}) {
    return SizedBox(
      height: width ?? 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 16),
            width: width ?? 160,
            child: GlobalCard(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(12),
              elevation: 3,
              isResponsive: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid({required int count}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        return GlobalCard(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12),
          elevation: 3,
          isResponsive: false,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
                ),
              ),
            ),
          ),
        );
      },
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
                              Text(
                                'Hai, ${_getFirstName(pengguna?.namaLengkap)}',
                                style: const TextStyle(
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
                          CustomCircleAvatar(
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
                      
                      // Sports Selection Section dengan TabView
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
                          
                          // TabView untuk filter jenis olahraga
                          TabViewHome(
                            onTabChanged: _onTabChanged,
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
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rekomendasi Untuk Anda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (isLoadingLapangan)
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Horizontal Cards
                if (isLoadingLapangan)
                  _buildLoadingCards(count: 4, width: 160)
                else if (featuredLapangan.isEmpty)
                  Container(
                    height: 160,
                    child: const Center(
                      child: Text(
                        'Tidak ada lapangan yang tersedia',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredLapangan.length,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, index) {
                        final field = featuredLapangan[index];
                        
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () => _navigateToDetail(field.id!),
                            child: _buildFieldCard(field, width: 160),
                          ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lapangan Populer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (isLoadingLapangan)
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Grid Cards
                if (isLoadingLapangan)
                  _buildLoadingGrid(count: 4)
                else if (popularLapangan.isEmpty)
                  Container(
                    height: 200,
                    child: const Center(
                      child: Text(
                        'Tidak ada lapangan populer yang tersedia',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: popularLapangan.length,
                    itemBuilder: (context, index) {
                      final field = popularLapangan[index];
                      return GestureDetector(
                        onTap: () => _navigateToDetail(field.id!),
                        child: _buildFieldCard(field),
                      );
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

