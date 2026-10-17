import 'package:flutter/material.dart';
import '../models/university.dart';
import '../theme/app_theme.dart';
import 'deadline_badge.dart';

class UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<ApplicationStatus> onStatusChanged;
  final VoidCallback onToggleApplied;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
    required this.onToggleApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Flag & 2. University Name + Popup Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Flag
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.borderColor.withOpacity(0.8)),
                      ),
                      child: Text(
                        university.countryFlag,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // University Name
                    Expanded(
                      child: Text(
                        university.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryText,
                          letterSpacing: -0.3,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Actions Menu (Edit, Delete, Toggle)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded,
                          size: 19, color: AppTheme.secondaryText),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 140),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      onSelected: (val) {
                        if (val == 'edit') onEdit();
                        if (val == 'delete') onDelete();
                        if (val == 'toggle') onToggleApplied();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                university.isApplied
                                    ? Icons.undo_rounded
                                    : Icons.check_circle_outline_rounded,
                                size: 18,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                university.isApplied
                                    ? 'Mark Not Applied'
                                    : 'Mark as Applied',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 18, color: AppTheme.secondaryText),
                              SizedBox(width: 8),
                              Text('Edit University',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  size: 18, color: AppTheme.danger),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(
                                      fontSize: 13, color: AppTheme.danger)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 3. Due Date & 4. Status (Applied / Not Applied)
                Row(
                  children: [
                    // Due Date
                    Expanded(
                      child: DeadlineBadge(
                        deadline: university.deadline,
                        showDate: true,
                        compact: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Status (Applied / Not Applied)
                    InkWell(
                      onTap: onToggleApplied,
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: university.isApplied
                              ? AppTheme.successBg
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: university.isApplied
                                ? AppTheme.success.withOpacity(0.35)
                                : AppTheme.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              university.isApplied
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 13,
                              color: university.isApplied
                                  ? AppTheme.success
                                  : AppTheme.secondaryText,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              university.isApplied ? 'Applied' : 'Not Applied',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: university.isApplied
                                    ? AppTheme.success
                                    : AppTheme.secondaryText,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
