import 'package:flutter/material.dart';
import '../data/university_repository.dart';
import '../theme/app_theme.dart';

class DashboardStatsBanner extends StatelessWidget {
  final UniversityRepository repository;
  final String activeFilter;
  final ValueChanged<String> onFilterSelected;

  const DashboardStatsBanner({
    super.key,
    required this.repository,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final total = repository.totalCount;
    final applied = repository.appliedCount;
    final wishlist = repository.wishlistCount;
    final fullyFunded = repository.fullyFundedCount;
    final urgent = repository.urgentDeadlinesCount;
    final appliedPercent = total > 0 ? (applied / total) : 0.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _StatTile(
            title: 'All Tracked',
            value: '$total',
            subtitle: 'Universities',
            icon: Icons.school_rounded,
            iconColor: const Color(0xFF3B82F6),
            bgColor: Colors.white,
            borderColor: activeFilter == 'all'
                ? const Color(0xFF3B82F6)
                : AppTheme.borderColor,
            isSelected: activeFilter == 'all',
            onTap: () => onFilterSelected('all'),
          ),
          const SizedBox(width: 12),
          _StatTile(
            title: 'Applied',
            value: '$applied',
            subtitle: '${(appliedPercent * 100).toInt()}% of total',
            progress: appliedPercent,
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF2563EB),
            bgColor: Colors.white,
            borderColor: activeFilter == 'applied'
                ? const Color(0xFF2563EB)
                : AppTheme.borderColor,
            isSelected: activeFilter == 'applied',
            onTap: () => onFilterSelected('applied'),
          ),
          const SizedBox(width: 12),
          _StatTile(
            title: 'Wishlist / Plan',
            value: '$wishlist',
            subtitle: 'Not yet applied',
            icon: Icons.bookmark_added_rounded,
            iconColor: const Color(0xFFD97706),
            bgColor: Colors.white,
            borderColor: activeFilter == 'wishlist'
                ? const Color(0xFFD97706)
                : AppTheme.borderColor,
            isSelected: activeFilter == 'wishlist',
            onTap: () => onFilterSelected('wishlist'),
          ),
          const SizedBox(width: 12),
          _StatTile(
            title: 'Fully Funded',
            value: '$fullyFunded',
            subtitle: 'Scholarships',
            icon: Icons.auto_awesome_rounded,
            iconColor: const Color(0xFF059669),
            bgColor: Colors.white,
            borderColor: activeFilter == 'fully_funded'
                ? const Color(0xFF059669)
                : AppTheme.borderColor,
            isSelected: activeFilter == 'fully_funded',
            onTap: () => onFilterSelected('fully_funded'),
          ),
          const SizedBox(width: 12),
          _StatTile(
            title: 'Urgent Deadlines',
            value: '$urgent',
            subtitle: 'Due within 30d',
            icon: Icons.access_time_filled_rounded,
            iconColor: const Color(0xFFDC2626),
            bgColor: Colors.white,
            borderColor: activeFilter == 'urgent'
                ? const Color(0xFFDC2626)
                : AppTheme.borderColor,
            isSelected: activeFilter == 'urgent',
            onTap: () => onFilterSelected('urgent'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double? progress;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatTile({
    required this.title,
    required this.value,
    required this.subtitle,
    this.progress,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 156,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? iconColor.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? iconColor : AppTheme.borderColor,
            width: isSelected ? 2.2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withOpacity(0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 19, color: iconColor),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? iconColor : AppTheme.primaryText,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                color: isSelected ? iconColor : AppTheme.primaryText,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: AppTheme.surfaceMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
