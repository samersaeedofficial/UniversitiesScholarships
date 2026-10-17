import 'package:flutter/material.dart';
import '../models/university.dart';

class ScholarshipBadge extends StatelessWidget {
  final ScholarshipType type;
  final bool compact;

  const ScholarshipBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  Color _bgColor() {
    switch (type) {
      case ScholarshipType.fullyFunded:
        return const Color(0xFFECFDF5);
      case ScholarshipType.tuitionWaiver:
        return const Color(0xFFF0FDFA);
      case ScholarshipType.partial:
        return const Color(0xFFEFF6FF);
      case ScholarshipType.needBased:
        return const Color(0xFFFFFBEB);
      case ScholarshipType.externalOnly:
        return const Color(0xFFFAF5FF);
      case ScholarshipType.none:
        return const Color(0xFFF8FAFC);
    }
  }

  Color _textColor() {
    switch (type) {
      case ScholarshipType.fullyFunded:
        return const Color(0xFF047857);
      case ScholarshipType.tuitionWaiver:
        return const Color(0xFF0F766E);
      case ScholarshipType.partial:
        return const Color(0xFF1D4ED8);
      case ScholarshipType.needBased:
        return const Color(0xFFB45309);
      case ScholarshipType.externalOnly:
        return const Color(0xFF7E22CE);
      case ScholarshipType.none:
        return const Color(0xFF64748B);
    }
  }

  Color _borderColor() {
    return _textColor().withOpacity(0.22);
  }

  IconData _icon() {
    switch (type) {
      case ScholarshipType.fullyFunded:
        return Icons.auto_awesome_rounded;
      case ScholarshipType.tuitionWaiver:
        return Icons.school_rounded;
      case ScholarshipType.partial:
        return Icons.payments_outlined;
      case ScholarshipType.needBased:
        return Icons.volunteer_activism_outlined;
      case ScholarshipType.externalOnly:
        return Icons.public_rounded;
      case ScholarshipType.none:
        return Icons.money_off_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _textColor();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3.5 : 5,
      ),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor(), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(), size: compact ? 12 : 14, color: text),
          const SizedBox(width: 5),
          Text(
            type.label,
            style: TextStyle(
              color: text,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
