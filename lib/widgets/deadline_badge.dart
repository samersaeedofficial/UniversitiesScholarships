import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeadlineBadge extends StatelessWidget {
  final DateTime deadline;
  final bool showDate;
  final bool compact;

  const DeadlineBadge({
    super.key,
    required this.deadline,
    this.showDate = true,
    this.compact = false,
  });

  int get _daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    return target.difference(today).inDays;
  }

  Color _badgeColor() {
    final days = _daysRemaining;
    if (days < 0) return const Color(0xFFEF4444); // Expired
    if (days <= 7) return const Color(0xFFDC2626); // Urgent
    if (days <= 30) return const Color(0xFFD97706); // Warning
    return const Color(0xFF2563EB); // Safe
  }

  Color _bgColor() {
    final days = _daysRemaining;
    if (days < 0) return const Color(0xFFFEF2F2);
    if (days <= 7) return const Color(0xFFFEF2F2);
    if (days <= 30) return const Color(0xFFFFFBEB);
    return const Color(0xFFEFF6FF);
  }

  String _label() {
    final days = _daysRemaining;
    if (days < 0) return 'Passed';
    if (days == 0) return 'Today!';
    if (days == 1) return 'Tomorrow';
    if (days <= 7) return '$days days left!';
    if (days <= 30) return '$days days left';
    final months = (days / 30.0).toStringAsFixed(1);
    return '${months.replaceAll('.0', '')} mo left';
  }

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor();
    final bg = _bgColor();
    final dateStr = compact
        ? DateFormat('MMM dd').format(deadline)
        : DateFormat('MMM dd, yyyy').format(deadline);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 9,
        vertical: compact ? 3.5 : 4.5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded,
              size: compact ? 11 : 12, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              showDate ? '$dateStr (${_label()})' : _label(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: compact ? 11 : 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
