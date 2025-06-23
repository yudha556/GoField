import 'package:flutter/material.dart';
import 'package:gofield/core/components/alerts/status_alert.dart';

class DialogAlert {
  static Future<bool?> show({
    required BuildContext context,
    required AlertStatus status,
    required String title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIcon(status),
                size: 48,
                color: _getIconColor(status),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  if (cancelText != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          onCancel?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(cancelText),
                      ),
                    ),
                  if (cancelText != null && confirmText != null)
                    const SizedBox(width: 12),
                  if (confirmText != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          onConfirm?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getIconColor(status),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(confirmText),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static IconData _getIcon(AlertStatus status) {
    switch (status) {
      case AlertStatus.success:
        return Icons.check_circle;
      case AlertStatus.pending:
        return Icons.access_time;
      case AlertStatus.rejected:
        return Icons.error;
      case AlertStatus.cancelled:
        return Icons.block;
      case AlertStatus.warning:
        return Icons.warning;
      case AlertStatus.info:
        return Icons.info;
    }
  }

  static Color _getIconColor(AlertStatus status) {
    switch (status) {
      case AlertStatus.success:
        return Colors.green;
      case AlertStatus.pending:
        return Colors.orange;
      case AlertStatus.rejected:
        return Colors.red;
      case AlertStatus.cancelled:
        return Colors.grey;
      case AlertStatus.warning:
        return Colors.amber;
      case AlertStatus.info:
        return Colors.blue;
    }
  }
}
