import 'package:flutter/material.dart';
import 'package:gofield/core/components/alerts/status_alert.dart';

class BannerAlert extends StatelessWidget {
  final AlertStatus status;
  final String title;
  final String? description;
  final VoidCallback? onClose;
  final VoidCallback? onAction;
  final String? actionText;
  final bool isDismissible;

  const BannerAlert({
    super.key,
    required this.status,
    required this.title,
    this.description,
    this.onClose,
    this.onAction,
    this.actionText,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(),
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getTextColor().withOpacity(0.8),
                    ),
                  ),
                ],
                if (onAction != null && actionText != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      actionText!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getIconColor(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isDismissible && onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                size: 18,
                color: _getTextColor().withOpacity(0.6),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
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

  Color _getIconColor() {
    switch (status) {
      case AlertStatus.success:
        return Colors.green.shade600;
      case AlertStatus.pending:
        return Colors.orange.shade600;
      case AlertStatus.rejected:
        return Colors.red.shade600;
      case AlertStatus.cancelled:
        return Colors.grey.shade500;
      case AlertStatus.warning:
        return Colors.amber.shade600;
      case AlertStatus.info:
        return Colors.blue.shade600;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case AlertStatus.success:
        return Colors.green.shade800;
      case AlertStatus.pending:
        return Colors.orange.shade800;
      case AlertStatus.rejected:
        return Colors.red.shade800;
      case AlertStatus.cancelled:
        return Colors.grey.shade700;
      case AlertStatus.warning:
        return Colors.amber.shade800;
      case AlertStatus.info:
        return Colors.blue.shade800;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case AlertStatus.success:
        return Icons.check_circle_outline;
      case AlertStatus.pending:
        return Icons.access_time;
      case AlertStatus.rejected:
        return Icons.error_outline;
      case AlertStatus.cancelled:
        return Icons.block;
      case AlertStatus.warning:
        return Icons.warning_amber;
      case AlertStatus.info:
        return Icons.info_outline;
    }
  }
}
