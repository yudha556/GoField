import 'package:flutter/material.dart';

enum AlertStatus { 
  success, 
  pending, 
  rejected, 
  cancelled, 
  warning, 
  info 
}

class StatusAlert extends StatelessWidget {
  final AlertStatus status;
  final String? customMessage;
  final VoidCallback? onTap;
  final bool showIcon;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool isCompact;

  const StatusAlert({
    super.key,
    required this.status,
    this.customMessage,
    this.onTap,
    this.showIcon = true,
    this.width,
    this.padding,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12, 
        vertical: isCompact ? 4 : 8
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getIcon(),
                color: _getTextColor(),
                size: isCompact ? 14 : 16,
              ),
              SizedBox(width: isCompact ? 4 : 6),
            ],
            Flexible(
              child: Text(
                customMessage ?? _getDefaultMessage(),
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: isCompact ? 11 : 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case AlertStatus.success:
        return Colors.green.shade50;
      case AlertStatus.pending:
        return Colors.orange.shade50;
      case AlertStatus.rejected:
        return Colors.red.shade50;
      case AlertStatus.cancelled:
        return Colors.grey.shade50;
      case AlertStatus.warning:
        return Colors.amber.shade50;
      case AlertStatus.info:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case AlertStatus.success:
        return Colors.green.shade200;
      case AlertStatus.pending:
        return Colors.orange.shade200;
      case AlertStatus.rejected:
        return Colors.red.shade200;
      case AlertStatus.cancelled:
        return Colors.grey.shade300;
      case AlertStatus.warning:
        return Colors.amber.shade200;
      case AlertStatus.info:
        return Colors.blue.shade200;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case AlertStatus.success:
        return Colors.green.shade700;
      case AlertStatus.pending:
        return Colors.orange.shade700;
      case AlertStatus.rejected:
        return Colors.red.shade700;
      case AlertStatus.cancelled:
        return Colors.grey.shade600;
      case AlertStatus.warning:
        return Colors.amber.shade700;
      case AlertStatus.info:
        return Colors.blue.shade700;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case AlertStatus.success:
        return Icons.check_circle;
      case AlertStatus.pending:
        return Icons.access_time;
      case AlertStatus.rejected:
        return Icons.cancel;
      case AlertStatus.cancelled:
        return Icons.block;
      case AlertStatus.warning:
        return Icons.warning;
      case AlertStatus.info:
        return Icons.info;
    }
  }

  String _getDefaultMessage() {
    switch (status) {
      case AlertStatus.success:
        return 'Berhasil';
      case AlertStatus.pending:
        return 'Menunggu';
      case AlertStatus.rejected:
        return 'Ditolak';
      case AlertStatus.cancelled:
        return 'Dibatalkan';
      case AlertStatus.warning:
        return 'Peringatan';
      case AlertStatus.info:
        return 'Informasi';
    }
  }
}
