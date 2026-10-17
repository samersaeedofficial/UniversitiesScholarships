import 'package:flutter/material.dart';
import '../models/university.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final ApplicationStatus status;
  final bool isInteractive;
  final ValueChanged<ApplicationStatus>? onStatusChanged;

  const StatusBadge({
    super.key,
    required this.status,
    this.isInteractive = false,
    this.onStatusChanged,
  });

  Color _bgColor() {
    switch (status) {
      case ApplicationStatus.wishlist:
        return const Color(0xFFF1F5F9);
      case ApplicationStatus.inProgress:
        return const Color(0xFFFFFBEB);
      case ApplicationStatus.applied:
        return const Color(0xFFEEF2FF);
      case ApplicationStatus.interview:
        return const Color(0xFFFAF5FF);
      case ApplicationStatus.accepted:
        return const Color(0xFFECFDF5);
      case ApplicationStatus.rejected:
        return const Color(0xFFFEF2F2);
    }
  }

  Color _textColor() {
    switch (status) {
      case ApplicationStatus.wishlist:
        return const Color(0xFF475569);
      case ApplicationStatus.inProgress:
        return const Color(0xFFB45309);
      case ApplicationStatus.applied:
        return const Color(0xFF1D4ED8);
      case ApplicationStatus.interview:
        return const Color(0xFF7E22CE);
      case ApplicationStatus.accepted:
        return const Color(0xFF047857);
      case ApplicationStatus.rejected:
        return const Color(0xFFB91C1C);
    }
  }

  IconData _icon() {
    switch (status) {
      case ApplicationStatus.wishlist:
        return Icons.bookmark_border_rounded;
      case ApplicationStatus.inProgress:
        return Icons.hourglass_top_rounded;
      case ApplicationStatus.applied:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.interview:
        return Icons.video_camera_front_rounded;
      case ApplicationStatus.accepted:
        return Icons.celebration_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor();
    final text = _textColor();

    if (!isInteractive || onStatusChanged == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: text.withOpacity(0.2), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon(), size: 12, color: text),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                status.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: text,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return PopupMenuButton<ApplicationStatus>(
      initialValue: status,
      onSelected: onStatusChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      itemBuilder: (context) => ApplicationStatus.values.map((s) {
        return PopupMenuItem(
          value: s,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: s == status ? AppTheme.primary : AppTheme.mutedText,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s.label,
                    style: TextStyle(
                      fontWeight:
                          s == status ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13.5,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  Text(
                    s.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: text.withOpacity(0.25), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon(), size: 12, color: text),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                status.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: text,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.arrow_drop_down_rounded, size: 15, color: text),
          ],
        ),
      ),
    );
  }
}
