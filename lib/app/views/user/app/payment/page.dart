import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/app/payment/components/schedule_grid.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/app/views/user/app/payment/components/date_selector.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/services/lapanganService.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';
import 'package:gofield/app/views/user/app/payment/components/tabView.dart';

class PaymentPage extends StatelessWidget {
  final String lapanganId;

  const PaymentPage({super.key, required this.lapanganId});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: MainUserScaffold(
        showNavBar: false,
        child: SafeArea(child: PaymentContent(lapanganId: lapanganId)),
      ),
    );
  }
}

class PaymentContent extends StatefulWidget {
  final String lapanganId;

  const PaymentContent({super.key, required this.lapanganId});

  @override
  State<PaymentContent> createState() => _PaymentContentState();
}

class _PaymentContentState extends State<PaymentContent> {
  LapanganDetailModel? _lapangan;
  bool _isLoading = true;
  int _selectedLaneIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchLapanganDetail();
  }

  Future<void> _fetchLapanganDetail() async {
    try {
      final result = await LapanganService.getDetailLapangan(widget.lapanganId);
      setState(() {
        _lapangan = result;
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal fetch detail lapangan: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _lapangan == null
            ? const Center(child: Text('Gagal memuat data lapangan'))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header dan Date Selector
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF0088E8), Color(0xFF4DACEF), Colors.white],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Pilih Jadwal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(Icons.calendar_month_outlined, size: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -40,
                          left: 24,
                          right: 24,
                          child: DateScrollView(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // TransaksiTab
                    _lapangan!.lanes != null && _lapangan!.lanes!.isNotEmpty
                        ? TransaksiTab(
                            lanes: _lapangan!.lanes!,
                            selectedLaneIndex: _selectedLaneIndex,
                            onLaneSelected: (lane) {
                              final index = _lapangan!.lanes!.indexWhere((l) => l.id == lane.id);
                              if (index != -1) {
                                setState(() {
                                  _selectedLaneIndex = index;
                                });
                              }
                            },
                          )
                        : const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Belum ada lane tersedia.'),
                          ),

                    const SizedBox(height: 20),

                    // Legenda Warna
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLegend(Colors.red, 'Tidak Tersedia'),
                          _buildLegend(Colors.grey, 'Tersedia'),
                          _buildLegend(Colors.green, 'Dipilih'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Schedule Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ScheduleGrid(
                        lane: _lapangan!.lanes![_selectedLaneIndex],
                      ),
                    ),

                    const SizedBox(height: 12),

                    PrimaryButton(
                      text: 'Lanjut Checkout',
                      onPressed: () {
                        context.go(AppRoutes.userCheckoutPath(widget.lapanganId));
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
