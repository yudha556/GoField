import 'package:flutter/material.dart';
import 'package:gofield/core/models/reservasi_models.dart';
import 'package:gofield/core/services/reservasiService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> data;
  
  const CheckoutPage({Key? key, required this.data}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'transfer';
  final TextEditingController notesController = TextEditingController();
  bool isProcessing = false;
  bool _isLocaleInitialized = false;

  late String lapanganId;
  late DateTime tanggal;
  late Map<String, dynamic> lane;
  late List<String> jamList;

  // Declare variables as instance variables
  late final int hargaPerJam;
  late final int durasi;
  late final int totalHarga;
  late final String waktuMulai;
  late final String waktuSelesai;
  String formatTanggal = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeLocale();
  }

  void _initializeData() {
    final data = widget.data;
    lapanganId = data['lapanganId'] as String;
    tanggal = data['tanggal'] as DateTime;
    lane = data['lane'] as Map<String, dynamic>;
    jamList = List<String>.from(data['jam'] as List);

    hargaPerJam = (lane['harga_per_jam'] as num).toInt();
    waktuMulai = jamList.first;
    waktuSelesai = jamList.last;
    durasi = jamList.length;
    totalHarga = hargaPerJam * durasi;
    
    // Use default date format initially
    formatTanggal = DateFormat('EEEE, d MMMM yyyy').format(tanggal);
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      if (mounted) {
        setState(() {
          _isLocaleInitialized = true;
          // Update format with Indonesian locale
          formatTanggal = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(tanggal);
        });
      }
    } catch (e) {
      print('Failed to initialize Indonesian locale: $e');
      // Fallback to default locale
      if (mounted) {
        setState(() {
          _isLocaleInitialized = true;
          formatTanggal = DateFormat('EEEE, d MMMM yyyy').format(tanggal);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7DD3FC), Color(0xFF60A5FA)],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Informasi Lapangan & Lane
            _buildFieldInfoSection(),
            const SizedBox(height: 16),

            // Detail Jadwal Pemesanan
            _buildScheduleSection(),
            const SizedBox(height: 16),

            // Rincian Biaya
            _buildCostSection(),
            const SizedBox(height: 16),

            // Metode Pembayaran
            _buildPaymentSection(),
            const SizedBox(height: 16),

            // Ringkasan Reservasi
            _buildSummarySection(),
            const SizedBox(height: 100), // Space for floating button
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x667DD3FC),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.credit_card, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Bayar Sekarang - Rp ${_formatCurrency(totalHarga)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _formatCurrency(int amount) {
    try {
      return NumberFormat('#,###', 'id_ID').format(amount);
    } catch (e) {
      // Fallback to default formatting if Indonesian locale fails
      return NumberFormat('#,###').format(amount);
    }
  }

  Widget _buildFieldInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text(
                'Informasi Lapangan & Lane',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lane['nama_lapangan'] ?? '-',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lane['alamat_lapangan'] ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nama Lane: ${lane['nama_lane'] ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Jenis Olahraga: ${lane['jenis_olahraga'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: const Border(
                      left: BorderSide(color: Color(0xFF38BDF8), width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kapasitas',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lane['kapasitas_pemain']} Orang',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: const Border(
                      left: BorderSide(color: Color(0xFF38BDF8), width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga per Jam',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${_formatCurrency(lane['harga_per_jam'])}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text(
                'Detail Jadwal Pemesanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanggal: $formatTanggal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '⏰ $waktuMulai - $waktuSelesai WIB',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jam: ${jamList.join(', ')}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Catatan (Opsional)',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tambahkan catatan khusus untuk pemesanan ini...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF38BDF8)),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.attach_money, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text(
                'Rincian Biaya',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Harga per Jam',
            'Rp ${_formatCurrency(hargaPerJam)}',
          ),
          _buildPriceRow('Durasi', '$durasi Jam'),
          _buildPriceRow(
            'Subtotal',
            'Rp ${_formatCurrency(totalHarga)}',
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
                Text(
                  'Rp ${_formatCurrency(totalHarga)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPaymentMethod(
            'transfer',
            Icons.smartphone,
            'Transfer Bank',
            'BCA, Mandiri, BNI, BRI',
          ),
          const SizedBox(height: 8),
          _buildPaymentMethod(
            'ewallet',
            Icons.flash_on,
            'E-Wallet',
            'GoPay, OVO, Dana, ShopeePay',
          ),
          const SizedBox(height: 8),
          _buildPaymentMethod(
            'cash',
            Icons.location_on,
            'Bayar di Tempat',
            'Pembayaran langsung di lokasi',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    String value,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(0xFF38BDF8)
                : const Color(0xFFE2E8F0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFF0F9FF) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFF38BDF8),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
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

  Widget _buildSummarySection() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 Ringkasan Reservasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Lapangan:', lane['nama_lapangan'] ?? '-'),
          _buildSummaryRow('Lane:', lane['nama_lane'] ?? '-'),
          _buildSummaryRow('Jenis Olahraga:', lane['nama_jenis'] ?? '-'),
          _buildSummaryRow('Tanggal:', formatTanggal),
          _buildSummaryRow('Jam:', '$waktuMulai - $waktuSelesai'),
          _buildSummaryRow('Durasi:', '$durasi Jam'),
          _buildSummaryRow(
            'Total:',
            'Rp ${_formatCurrency(totalHarga)}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final reservasi = ReservasiModel(
        idPengguna: userId,
        idLapangan: lapanganId,
        idLane: lane['id_lane'],
        idJadwal: '', // isi jika ada
        tanggalReservasi: tanggal,
        waktuMulai: jamList.first,
        waktuSelesai: jamList.last,
        durasiJam: jamList.length.toDouble(),
        totalHarga: lane['harga_per_jam'] * jamList.length,
        catatan: notesController.text,
      );

      await ReservasiService().buatReservasi(reservasi);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal melakukan reservasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pemesanan Berhasil!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Terima kasih! Pemesanan lapangan Anda telah berhasil diproses. Kami akan mengirimkan konfirmasi melalui email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to previous page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7DD3FC), Color(0xFF38BDF8)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
