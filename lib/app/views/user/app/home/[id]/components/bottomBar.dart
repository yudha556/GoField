import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';

class DetailLapanganBottomBar extends StatelessWidget {
  final bool isAvailable;
  final VoidCallback onChatPressed;
  final VoidCallback onBookingPressed;
  final double? lowestPrice;
  final String? status;
  final String lapanganId;

  const DetailLapanganBottomBar({
    super.key,
    required this.isAvailable,
    required this.onChatPressed,
    required this.onBookingPressed,
    required this.lapanganId,
    this.lowestPrice,
    this.status,
  });

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _getButtonText() {
    if (status == null) return 'Tidak Tersedia';

    switch (status!) {
      case 'buka':
        return 'Pesan Sekarang';
      case 'tutup':
        return 'Tidak Tersedia';
      case 'maintenance':
        return 'Sedang Dipesan';
      default:
        return 'Tidak Tersedia';
    }
  }

  Color _getButtonColor() {
    if (status == null) return Colors.grey;

    switch (status!) {
      case 'buka':
        return const Color(0xFF0088E8);
      case 'tutup':
        return Colors.grey;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lowestPrice != null && isAvailable) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mulai dari',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '${_formatCurrency(lowestPrice!)}/jam',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0088E8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    onPressed: onChatPressed,
                    icon: const Icon(Icons.chat_bubble_outline, size: 20),
                    label: const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0088E8),
                      side: const BorderSide(
                        color: Color(0xFF0088E8),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: lapanganId != null
                        ? () =>
                              context.go(AppRoutes.userPaymentPath(lapanganId!))
                        : null,

                    icon: Icon(
                      isAvailable ? Icons.calendar_today : Icons.block,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: isAvailable ? 2 : 0,
                      shadowColor: isAvailable
                          ? const Color(0xFF0088E8).withOpacity(0.3)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative: Floating Action Button Style
class DetailLapanganFloatingButtons extends StatelessWidget {
  final bool isAvailable;
  final VoidCallback onChatPressed;
  final VoidCallback onBookingPressed;

  const DetailLapanganFloatingButtons({
    super.key,
    required this.isAvailable,
    required this.onChatPressed,
    required this.onBookingPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Chat Button
        FloatingActionButton(
          onPressed: onChatPressed,
          backgroundColor: Colors.green,
          heroTag: "chat",
          tooltip: 'Chat dengan Pemilik',
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),

        const SizedBox(height: 16),

        // Booking Button
        FloatingActionButton.extended(
          onPressed: onBookingPressed,
          backgroundColor: const Color(0xFF0088E8),
          heroTag: "booking",
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          label: const Text(
            'Pesan Sekarang',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Alternative: Compact Bottom Bar
class CompactDetailBottomBar extends StatelessWidget {
  final bool isAvailable;
  final VoidCallback onChatPressed;
  final VoidCallback onBookingPressed;
  final double? lowestPrice;
  final String lapanganId;

  const CompactDetailBottomBar({
    super.key,
    required this.isAvailable,
    required this.onChatPressed,
    required this.onBookingPressed,
    this.lowestPrice,
    required this.lapanganId,
  });

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Info
            if (lowestPrice != null && isAvailable) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Mulai dari',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${_formatCurrency(lowestPrice!)}/jam',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0088E8),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],

            // Buttons
            Expanded(
              child: Row(
                children: [
                  // Chat Button
                  if (isAvailable) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onChatPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0088E8),
                          side: const BorderSide(color: Color(0xFF0088E8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Booking Button
                  Expanded(
                    flex: isAvailable ? 2 : 1,
                    child: ElevatedButton(
                      onPressed: isAvailable ? onBookingPressed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAvailable
                            ? const Color(0xFF0088E8)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isAvailable ? 'Pesan Sekarang' : 'Tidak Tersedia',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
