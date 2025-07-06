import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/app/transaksi/components/tab.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/core/services/reservasiService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(child: SafeArea(child: TransaksiContent())),
    );
  }
}

class TransaksiContent extends StatefulWidget {
  const TransaksiContent({super.key});

  @override
  State<TransaksiContent> createState() => _TransaksiContentState();
}

class _TransaksiContentState extends State<TransaksiContent> {
  late Future<List<Map<String, dynamic>>> _riwayatFuture;
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocaleAndData();
  }

  // Inisialisasi locale dan data
  void _initializeLocaleAndData() async {
    // Inisialisasi locale Indonesia
    await initializeDateFormatting('id_ID', null);
    
    setState(() {
      _isLocaleInitialized = true;
      final userId = Supabase.instance.client.auth.currentUser!.id;
      _riwayatFuture = ReservasiService().fetchRiwayatReservasi(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const TransaksiTab(),
        Expanded(
          child: !_isLocaleInitialized
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<Map<String, dynamic>>>(
                  future: _riwayatFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Gagal memuat data'));
                    }
                    final data = snapshot.data ?? [];
                    if (data.isEmpty) {
                      return const Center(child: Text('Belum ada transaksi'));
                    }
                    final grouped = _groupTransactionsByDate(data);
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: grouped.length,
                      itemBuilder: (context, index) {
                        final dateGroup = grouped[index];
                        return _buildDateGroup(context, dateGroup);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Text(
        'Riwayat Transaksi',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDateGroup(BuildContext context, Map<String, dynamic> dateGroup) {
    final String date = dateGroup['date'];
    final List<Map<String, dynamic>> transactions = dateGroup['transactions'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDateHeader(date, transactions.length),
          _buildTransactionsList(transactions),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date, int transactionCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            '$transactionCount transaksi',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<Map<String, dynamic>> transactions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.shade200,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        return _buildTransactionItem(context, transactions[index]);
      },
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(width: 12),
          _buildTransactionInfo(transaction),
          _buildTransactionStatus(context, transaction),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo(Map<String, dynamic> transaction) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction['fieldName'],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                transaction['time'],
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            transaction['price'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionStatus(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StatusAlert(status: transaction['status'], isCompact: true),
        const SizedBox(height: 8),
        LinkButton(
          text: 'Detail',
          size: ButtonSize.small,
          onPressed: () => context.go(AppRoutes.userTransactionDetail),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _groupTransactionsByDate(List<Map<String, dynamic>> data) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final trx in data) {
      final date = DateFormat('EEEE, d MMMM yyyy', 'id_ID')
          .format(DateTime.parse(trx['tanggal_reservasi']));
      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add({
        'id': trx['id_reservasi'],
        'fieldName': trx['lapangan']['nama_lapangan'] ?? '-',
        'time': '${trx['waktu_mulai_reservasi']} - ${trx['waktu_selesai_reservasi']}',
        'price': 'Rp ${NumberFormat('#,###', 'id_ID').format(trx['total_harga'])}',
        'status': _mapStatus(trx['status_reservasi']),
      });
    }
    return grouped.entries.map((e) => {
      'date': e.key,
      'transactions': e.value,
    }).toList();
  }

  AlertStatus _mapStatus(String status) {
    switch (status) {
      case 'berhasil':
      case 'dikonfirmasi':
        return AlertStatus.success;
      case 'menunggu':
      case 'pending':
        return AlertStatus.pending;
      case 'batal':
      case 'dibatalkan':
        return AlertStatus.cancelled;
      case 'ditolak':
      case 'selesai':
        return AlertStatus.rejected;
      default:
        return AlertStatus.pending;
    }
  }
}