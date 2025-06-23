import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({super.key});

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  bool _showRincian = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan back button
            CustomBackButton(
              title: 'Detail Transaksi',
              backgroundColor: Colors.white,
              onPressed: () {
                context.go(AppRoutes.usertransaksiPage);
              },
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 18,
                      ),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const StatusAlert(
                            status: AlertStatus.success,
                            isCompact: true,
                          ),
                        ],
                      ),
                    ),
                    
                    // Divider abu-abu
                    Container(
                      color: Colors.grey.shade300,
                      height: 8,
                      width: double.infinity,
                    ),
                    
                    // Info Transaksi Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Info Transaksi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          Container(
                            color: Colors.grey.shade300,
                            width: double.infinity,
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          
                          // Nomor Pesanan dengan tombol salin
                          _buildNomorPesananItem('Nomor Pesanan', 'TRX001'),
                          _buildDivider(),
                          _buildVerticalInfoItem('Tanggal Transaksi', '15 Januari 2024'),
                          _buildDivider(),
                          // Total dengan dropdown rincian
                          _buildTotalPembayaranItem(),
                          _buildDivider(),
                          _buildVerticalInfoItem('Metode Pembayaran', 'Transfer Bank'),
                        ],
                      ),
                    ),
                    
                    // Divider abu-abu
                    Container(
                      color: Colors.grey.shade300,
                      height: 8,
                      width: double.infinity,
                    ),
                    
                    // Detail Booking Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail Booking',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          Container(
                            color: Colors.grey.shade300,
                            width: double.infinity,
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          
                          // Info lapangan dengan icon
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.sports_soccer,
                                  color: Colors.green.shade600,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lapangan Futsal A',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Futsal Indoor Premium',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildVerticalInfoItem('Tanggal Main', '15 Januari 2024'),
                          _buildDivider(),
                          _buildVerticalInfoItem('Waktu', '14:00 - 16:00'),
                          _buildDivider(),
                          _buildVerticalInfoItem('Durasi', '2 Jam'),
                          _buildDivider(),
                          _buildVerticalInfoItem('Harga per Jam', 'Rp 75.000'),
                        ],
                      ),
                    ),
                    
                    // Divider abu-abu
                    Container(
                      color: Colors.grey.shade300,
                      height: 8,
                      width: double.infinity,
                    ),
                    
                    // Action Buttons Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          // Download Invoice Button - pakai SecondaryButton
                          Row(
                            children: [
                              Icon(Icons.contact_support_outlined),
                              SizedBox(width: 8,),
                              Text(
                                'Butuh bantuan untuk transaksi ini?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                                ),
                              )
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Hubungi CS Button - pakai PrimaryButton
                          PrimaryButton(
                            text: 'Hubungi Customer Service',
                            icon: Icons.support_agent,
                            isFullWidth: true,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Menghubungi Customer Service')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget khusus untuk nomor pesanan dengan tombol salin - pakai LinkButton
  Widget _buildNomorPesananItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              LinkButton(
                text: 'Salin',
                size: ButtonSize.small,
                icon: Icons.copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nomor pesanan $value berhasil disalin'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green.shade600,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget khusus untuk total pembayaran dengan dropdown rincian - pakai LinkButton
  Widget _buildTotalPembayaranItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Pembayaran',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rp 150.000',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              LinkButton(
                text: 'Rincian',
                size: ButtonSize.small,
                icon: _showRincian ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                iconRight: true,
                onPressed: () {
                  setState(() {
                    _showRincian = !_showRincian;
                  });
                },
              ),
            ],
          ),
          
          // Dropdown rincian
          if (_showRincian) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildRincianRow('Harga Lapangan (2 jam)', 'Rp 150.000'),
                  _buildRincianRow('Biaya Service', 'Rp 5.000'),
                  _buildRincianRow('Diskon', '- Rp 5.000'),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  _buildRincianRow('Total Keseluruhan', 'Rp 150.000', isTotal: true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper method untuk buat info item vertikal
  Widget _buildVerticalInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk buat garis pemisah
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.grey.shade200,
      width: double.infinity,
      height: 1,
    );
  }

  // Helper untuk buat row rincian
  Widget _buildRincianRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 13 : 12,
              color: isTotal ? Colors.black : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 13 : 12,
              color: isTotal ? Colors.black : Colors.grey.shade700,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
