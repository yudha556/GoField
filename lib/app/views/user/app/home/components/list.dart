import 'package:flutter/material.dart';
import 'package:gofield/app/views/user/app/home/components/tabView.dart';
import 'package:gofield/core/models/lapangan_model.dart';
import 'package:gofield/core/services/lapanganService.dart';
import 'package:gofield/core/components/components.dart';
import 'package:go_router/go_router.dart';

class LapanganListView extends StatefulWidget {
  const LapanganListView({super.key});

  @override
  State<LapanganListView> createState() => _LapanganListViewState();
}

class _LapanganListViewState extends State<LapanganListView> {
  List<LapanganModel> lapanganList = [];
  Map<String, double?> lapanganPrices = {};
  bool isLoading = false;
  int selectedTabIndex = 0;
  String? selectedJenisOlahragaId;

  @override
  void initState() {
    super.initState();
    _loadLapangan();
  }

  Future<void> _loadLapangan({String? jenisOlahragaId}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final lapangan = await LapanganService.ambilSemuaLapangan(
        jenisOlahragaId: jenisOlahragaId,
      );

      await _loadPricesForLapangan(lapangan);

      if (mounted) {
        setState(() {
          lapanganList = lapangan;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading lapangan: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPricesForLapangan(List<LapanganModel> lapangan) async {
    for (var field in lapangan) {
      if (field.id != null) {
        try {
          final price = await LapanganService.getLowestPriceByLapangan(field.id!);
          lapanganPrices[field.id!] = price;
        } catch (e) {
          print('Error loading price for lapangan ${field.id}: $e');
          lapanganPrices[field.id!] = null;
        }
      }
    }
  }

  void _onTabChanged(int index, String? jenisOlahragaId) {
    setState(() {
      selectedTabIndex = index;
      selectedJenisOlahragaId = jenisOlahragaId;
    });
    _loadLapangan(jenisOlahragaId: jenisOlahragaId);
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

  Widget _buildLapanganCard(LapanganModel lapangan) {
    final lowestPrice = lapanganPrices[lapangan.id];

    return GlobalCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      isResponsive: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
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
                      fontSize: 10,
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

            // Overlay gradient
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

            // Text overlay
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
                      lapangan.namaLapangan,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lapangan.kecamatan ?? ''}, ${lapangan.kabupaten ?? ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${lapangan.kapasitas} orang',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
                                fontSize: 10,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabViewHome(
          onTabChanged: _onTabChanged, 
        ),
        
        const SizedBox(height: 16),
        
        // Content
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
              ),
            ),
          )
        else if (lapanganList.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Tidak ada lapangan yang tersedia',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lapanganList.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final lapangan = lapanganList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () => _navigateToDetail(lapangan.id!),
                  child: _buildLapanganCard(lapangan),
                ),
              );
            },
          ),
      ],
    );
  }
}
