import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/app/transaksi/components/tab.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';

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
      child: const MainUserScaffold(child: SafeArea(child: TransaksiContent())));
  }
}

class TransaksiContent extends StatelessWidget {
  const TransaksiContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const TransaksiTab(),
        _buildTransactionList(),
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

  Widget _buildTransactionList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _getGroupedTransactions().length,
        itemBuilder: (context, index) {
          final dateGroup = _getGroupedTransactions()[index];
          return _buildDateGroup(context, dateGroup);
        },
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
          // Icon(
          //   Icons.calendar_today,
          //   size: 16,
          //   color: Colors.grey.shade600,
          // ),
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

  Widget _buildTransactionItem(BuildContext context, Map<String, dynamic> transaction) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // _buildFieldIcon(transaction),
          const SizedBox(width: 12),
          _buildTransactionInfo(transaction),
          _buildTransactionStatus(context, transaction),
        ],
      ),
    );
  }

  // Widget _buildFieldIcon(Map<String, dynamic> transaction) {
  //   return Container(
  //     width: 48,
  //     height: 48,
  //     decoration: BoxDecoration(
  //       color: _getStatusColorFromAlert(transaction['status']).withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Icon(
  //       _getFieldIcon(transaction['fieldName']),
  //       color: _getStatusColorFromAlert(transaction['status']),
  //       size: 24,
  //     ),
  //   );
  // }

  Widget _buildTransactionInfo(Map<String, dynamic> transaction) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction['fieldName'],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                transaction['time'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
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

  Widget _buildTransactionStatus(BuildContext context, Map<String, dynamic> transaction) {
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

  // Color _getStatusColorFromAlert(AlertStatus status) {
  //   switch (status) {
  //     case AlertStatus.success:
  //       return Colors.green.shade700;
  //     case AlertStatus.pending:
  //       return Colors.orange.shade700;
  //     case AlertStatus.rejected:
  //       return Colors.red.shade700;
  //     case AlertStatus.cancelled:
  //       return Colors.grey.shade600;
  //     case AlertStatus.warning:
  //       return Colors.amber.shade700;
  //     case AlertStatus.info:
  //       return Colors.blue.shade700;
  //   }
  // }

  // IconData _getFieldIcon(String fieldName) {
  //   final String normalizedFieldName = fieldName.toLowerCase();
  //   if (normalizedFieldName.contains('futsal')) {
  //     return Icons.sports_soccer;
  //   } else if (normalizedFieldName.contains('badminton') || normalizedFieldName.contains('tenis')) {
  //     return Icons.sports_tennis;
  //   } else if (normalizedFieldName.contains('basket')) {
  //     return Icons.sports_basketball;
  //   }
  //   return Icons.sports;
  // }

  List<Map<String, dynamic>> _getGroupedTransactions() {
    return [
      {
        'date': 'Senin, 15 Januari 2024',
        'transactions': [
          {
            'id': 'TRX001',
            'fieldName': 'Lapangan Futsal A',
            'time': '14:00 - 16:00',
            'price': 'Rp 150.000',
            'status': AlertStatus.success,
          },
          {
            'id': 'TRX002',
            'fieldName': 'Lapangan Badminton B',
            'time': '19:00 - 21:00',
            'price': 'Rp 80.000',
            'status': AlertStatus.success,
          },
        ],
      },
      {
        'date': 'Selasa, 16 Januari 2024',
        'transactions': [
          {
            'id': 'TRX003',
            'fieldName': 'Lapangan Basket C',
            'time': '16:00 - 18:00',
            'price': 'Rp 200.000',
            'status': AlertStatus.pending,
          },
        ],
      },
      {
        'date': 'Rabu, 17 Januari 2024',
        'transactions': [
          {
            'id': 'TRX004',
            'fieldName': 'Lapangan Tenis D',
            'time': '08:00 - 10:00',
            'price': 'Rp 120.000',
            'status': AlertStatus.rejected,
          },
          {
            'id': 'TRX005',
            'fieldName': 'Lapangan Futsal B',
            'time': '15:00 - 17:00',
            'price': 'Rp 150.000',
            'status': AlertStatus.cancelled,
          },
          {
            'id': 'TRX006',
            'fieldName': 'Lapangan Voli A',
            'time': '20:00 - 22:00',
            'price': 'Rp 100.000',
            'status': AlertStatus.success,
          },
        ],
      },
    ];
  }
}