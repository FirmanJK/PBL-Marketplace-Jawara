import 'package:flutter/material.dart';

/// Helper class untuk menampilkan toast/popup notification
/// Gunakan: ToastHelper.showSuccess(context, 'Berhasil!')
class ToastHelper {
  /// Tampilkan popup success (hijau) di atas dengan animasi
  static void showSuccess(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      backgroundColor: const Color(0xFF10B981),
      icon: Icons.check_circle,
      duration: const Duration(seconds: 2),
    );
  }

  /// Tampilkan popup error (merah) di atas dengan animasi
  static void showError(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      backgroundColor: const Color(0xFFEF4444),
      icon: Icons.error,
      duration: const Duration(seconds: 3),
    );
  }

  /// Tampilkan popup warning (kuning) di atas dengan animasi
  static void showWarning(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      backgroundColor: const Color(0xFFF59E0B),
      icon: Icons.warning,
      duration: const Duration(seconds: 2),
    );
  }

  /// Tampilkan popup info (biru) di atas dengan animasi
  static void showInfo(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      backgroundColor: const Color(0xFF3B82F6),
      icon: Icons.info,
      duration: const Duration(seconds: 2),
    );
  }

  /// Custom toast dengan animasi dari atas
  static void _showCustomToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    late OverlayEntry overlayEntry;
    late AnimationController controller;

    try {
      final overlay = Overlay.of(context);

      overlayEntry = OverlayEntry(
        builder: (context) {
          controller = AnimationController(
            duration: const Duration(milliseconds: 400),
            vsync: overlay,
          );

          final animation =
              Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
              );

          controller.forward();

          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                child: SlideTransition(
                  position: animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: backgroundColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      overlay.insert(overlayEntry);

      Future.delayed(duration, () {
        try {
          overlayEntry.remove();
          controller.dispose();
        } catch (_) {
          // Ignore if already removed
        }
      });
    } catch (e) {
      // Ignore if context is invalid
      print('Toast error: $e');
    }
  }
}
