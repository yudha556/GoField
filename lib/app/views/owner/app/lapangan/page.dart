import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/owner/layout/main_owner_schalfold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/models/lapangan_model.dart';
import 'package:gofield/core/services/lapanganService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  List<LapanganModel> listLapangan = [];
  Map<String, double?> lapanganPrices = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLapangan();
  }

  Future<void> _loadLapangan() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User tidak ditemukan');
      }

      final pemilikRes = await Supabase.instance.client
          .from('pemilik_lapangan')
          .select('id_pemilik')
          .eq('id_pengguna', user.id)
          .single();

      final idPemilik = pemilikRes['id_pemilik'];
      final lapangan = await LapanganService.ambilLapanganByPemilik(idPemilik);
      await _loadPricesForLapangan(lapangan);

      if (mounted) {
        setState(() {
          listLapangan = lapangan;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading lapangan: $e');
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPricesForLapangan(List<LapanganModel> lapanganList) async {
    for (var lapangan in lapanganList) {
      if (lapangan.id != null) {
        try {
          final lanesResponse = await Supabase.instance.client
              .from('lane_lapangan')
              .select('harga_per_jam')
              .eq('id_lapangan', lapangan.id!)
              .eq('aktif', true) 
              .not('harga_per_jam', 'is', null);

          if (lanesResponse.isNotEmpty) {
            double? lowestPrice;
            for (var lane in lanesResponse) {
              final price = lane['harga_per_jam']?.toDouble();
              if (price != null) {
                if (lowestPrice == null || price < lowestPrice) {
                  lowestPrice = price;
                }
              }
            }
            lapanganPrices[lapangan.id!] = lowestPrice;
          } else {
            lapanganPrices[lapangan.id!] = null;
          }
        } catch (e) {
          print('Error loading price for lapangan ${lapangan.id}: $e');
          lapanganPrices[lapangan.id!] = null;
        }
      }
    }
  }

  Future<void> _refreshLapangan() async {
    await _loadLapangan();
  }

  String _formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _navigateToDetail(LapanganModel lapangan) {
    context.go(AppRoutes.ownerLapanganDetailPath(lapangan.id!));
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
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: //field.urlGambar.isNotEmpty
                      //     ? Image.network(
                      //         field.urlGambar.first,
                      //         fit: BoxFit.cover,
                      //         width: double.infinity,
                      //         height: double.infinity,
                      //         errorBuilder: (context, error, stackTrace) {
                      //           return const Icon(
                      //             Icons.sports_soccer,
                      //             size: 60,
                      //             color: Colors.grey,
                      //           );
                      //         },
                      //       )
                      const Icon(
                        Icons.sports_soccer,
                        size: 60,
                        color: Colors.grey,
                      ),
                ),
              ),

              if (lowestPrice != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.sports_soccer, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Lapangan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai tambahkan lapangan pertama Anda\nuntuk menerima reservasi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.go(AppRoutes.tambahLapangan);
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Lapangan Pertama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088E8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          ),
          const SizedBox(height: 16),
          const Text(
            'Gagal Memuat Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Terjadi kesalahan saat memuat data lapangan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshLapangan,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088E8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data lapangan...',
            style: TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshLapangan,
      color: const Color(0xFF0088E8),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomSearchBar(
                                hintText: 'Cari lapangan...',
                                onTap: () {},
                                onFilterTap: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
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

            // Content Area
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 200,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLoading && listLapangan.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lapangan Saya (${listLapangan.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              if (lapanganPrices.values.any(
                                (price) => price != null,
                              ))
                                Text(
                                  _getPriceRangeText(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: _refreshLapangan,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Refresh'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0088E8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Content berdasarkan state
                    if (isLoading)
                      _buildLoadingState()
                    else if (errorMessage != null)
                      _buildErrorState()
                    else if (listLapangan.isEmpty)
                      _buildEmptyState()
                    else
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
                          return GestureDetector(
                            onTap: () {
                              _navigateToDetail(listLapangan[index]);
                            },
                            child: _buildFieldCard(
                              listLapangan[index],
                              width: MediaQuery.of(context).size.width / 2 - 24,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            if (!isLoading && listLapangan.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.go(AppRoutes.tambahLapangan);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah Lapangan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _getPriceRangeText() {
    final prices = lapanganPrices.values
        .where((price) => price != null)
        .cast<double>()
        .toList();

    if (prices.isEmpty) return '';

    if (prices.length == 1) {
      return 'Harga: Rp ${_formatCurrency(prices.first)}/jam';
    }

    prices.sort();
    final lowest = prices.first;
    final highest = prices.last;

    if (lowest == highest) {
      return 'Harga: Rp ${_formatCurrency(lowest)}/jam';
    }

    return 'Harga: Rp ${_formatCurrency(lowest)} - Rp ${_formatCurrency(highest)}/jam';
  }
}
