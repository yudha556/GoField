import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/owner/app/confirm/components/tabView.dart';
import 'package:gofield/app/views/owner/layout/main_owner_schalfold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/services/reservasiService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainOwnerSchallfold(
        child: SafeArea(child: ConfirmContent()),
      ),
    );
  }
}

class ConfirmContent extends StatefulWidget {
  const ConfirmContent({super.key});

  @override
  State<ConfirmContent> createState() => _ConfirmContentState();
}

class _ConfirmContentState extends State<ConfirmContent> {
  String? _currentFilter;
  late Future<List<Map<String, dynamic>>> _riwayatFuture;
  List<Map<String, dynamic>> _allData = []; 
  bool _isLocaleInitialized = false;
  final ReservasiService _reservasiService = ReservasiService();

  @override
  void initState() {
    super.initState();
    _initializeLocaleAndData();
  }

  // Inisialisasi locale dan data
  void _initializeLocaleAndData() async {
    try {
      // Inisialisasi locale Indonesia
      await initializeDateFormatting('id_ID', null);

      setState(() {
        _isLocaleInitialized = true;
        _refreshData();
      });
    } catch (e) {
      debugPrint('Error initializing locale: $e');
      setState(() {
        _isLocaleInitialized = true;
        _refreshData();
      });
    }
  }

  void _refreshData() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      _riwayatFuture = _reservasiService.fetchReservasiUntukOwner(userId).then((
        data,
      ) {
        _allData = data;
        final uniqueStatuses = data
            .map((trx) => trx['status_reservasi']?.toString().toLowerCase())
            .toSet();
        debugPrint('Unique statuses in data: $uniqueStatuses');
        debugPrint('Current filter: $_currentFilter');
        
        if (_currentFilter != null) {
          final filteredData = data.where((trx) {
            final status = trx['status_reservasi']?.toString().toLowerCase() ?? '';
            debugPrint('Checking status: $status against filter: $_currentFilter');
            
            // Map different status variations to filter categories
            switch (_currentFilter) {
              case 'menunggu':
                return status == 'menunggu';
              case 'selesai':
                return status == 'dikonfirmasi';
              case 'ditolak':
                return status == 'dibatalkan';
              default:
                return status == _currentFilter;
            }
          }).toList();
          
          debugPrint('Filtered data count: ${filteredData.length}');
          return filteredData;
        }
        debugPrint('Returning all data count: ${data.length}');
        return data;
      });
    }
  }

  void _updateStatus(String idReservasi, String newStatus) async {
    try {
      await _reservasiService.updateStatusReservasi(idReservasi, newStatus);
      _refreshData();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reservasi berhasil ${newStatus.toLowerCase()}'),
          backgroundColor: newStatus == 'dikonfirmasi'
              ? Colors.green
              : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah status: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showConfirmationDialog(String idReservasi, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi $action'),
          content: Text('Apakah Anda yakin ingin $action reservasi ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateStatus(idReservasi, action);
              },
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        ConfirmTab(
          // allData: _allData,
          onFilterChanged: (filter) {
            setState(() {
              _currentFilter = filter;
              _refreshData();
            });
          },
        ),
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
                      debugPrint('FutureBuilder error: ${snapshot.error}');
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text('Gagal memuat data: ${snapshot.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _refreshData();
                                setState(() {});
                              },
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    }

                    final data = snapshot.data ?? [];
                    debugPrint('Received ${data.length} reservasi');

                    if (data.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text('Belum ada permintaan reservasi'),
                          ],
                        ),
                      );
                    }

                    final grouped = _groupTransactionsByDate(data);
                    debugPrint('Grouped into ${grouped.length} date groups');

                    return RefreshIndicator(
                      onRefresh: () async {
                        _refreshData();
                        setState(() {});
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: grouped.length,
                        itemBuilder: (context, index) {
                          final dateGroup = grouped[index];
                          return _buildDateGroup(context, dateGroup);
                        },
                      ),
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
        'Permintaan Reservasi',
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
          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
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
            '$transactionCount reservasi',
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
    final bool isPending = transaction['status'] == AlertStatus.pending;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.sports_soccer, size: 20, color: Colors.green),
              const SizedBox(width: 12),
              _buildTransactionInfo(transaction),
              StatusAlert(status: transaction['status'], isCompact: true),
            ],
          ),
          // Tombol aksi hanya muncul jika status masih pending
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showConfirmationDialog(
                      transaction['id'],
                      'dibatalkan',
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showConfirmationDialog(
                      transaction['id'],
                      'dikonfirmasi',
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Terima'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
            transaction['fieldName'] ?? 'Lapangan',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          if (transaction['customerName'] != null) ...[
            const SizedBox(height: 2),
            Text(
              'Oleh: ${transaction['customerName']}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                transaction['time'] ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            transaction['price'] ?? '',
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

  List<Map<String, dynamic>> _groupTransactionsByDate(
    List<Map<String, dynamic>> data,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final trx in data) {
      try {
        debugPrint('Processing transaction: ${trx['id_reservasi']}');
        debugPrint('Raw transaction data: $trx');

        final tanggalReservasi = trx['tanggal_reservasi'];
        if (tanggalReservasi == null) {
          debugPrint('Skipping transaction with null tanggal_reservasi');
          continue;
        }

        final date = DateFormat(
          'EEEE, d MMMM yyyy',
          'id_ID',
        ).format(DateTime.parse(tanggalReservasi));

        grouped.putIfAbsent(date, () => []);
        grouped[date]!.add({
          'id': trx['id_reservasi'],
          'fieldName':
              trx['lapangan']?['nama_lapangan'] ?? 'Lapangan Tidak Diketahui',
          'customerName':
              trx['pengguna']?['nama_lengkap'] ?? 'Nama Tidak Diketahui',
          'time':
              '${trx['waktu_mulai_reservasi'] ?? ''} - ${trx['waktu_selesai_reservasi'] ?? ''}',
          'price':
              'Rp ${NumberFormat('#,###', 'id_ID').format(trx['total_harga'] ?? 0)}',
          'status': _mapStatus(trx['status_reservasi']),
        });
      } catch (e) {
        debugPrint('Error processing transaction: $e');
        debugPrint('Transaction data: $trx');
      }
    }

    return grouped.entries
        .map((e) => {'date': e.key, 'transactions': e.value})
        .toList();
  }

  AlertStatus _mapStatus(String? status) {
    final statusLower = status?.toLowerCase();
    debugPrint('Mapping status: $status -> $statusLower');

    switch (statusLower) {
      case 'diterima':
      case 'dikonfirmasi':
      case 'selesai':
        return AlertStatus.success;
      case 'menunggu':
      case 'pending':
        return AlertStatus.pending;
      case 'batal':
      case 'dibatalkan':
      case 'ditolak':
        return AlertStatus.cancelled;
      case 'rejected':
        return AlertStatus.rejected;
      default:
        debugPrint('Unknown status: $status, defaulting to pending');
        return AlertStatus.pending;
    }
  }
}