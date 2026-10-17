import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum SortOption {
  soonestDeadline('Soonest Deadline'),
  latestDeadline('Latest Deadline'),
  nameAsc('Name (A-Z)'),
  status('Status');

  final String label;
  const SortOption(this.label);
}

class FilterChipsBar extends StatelessWidget {
  final String selectedCountry;
  final List<String> availableCountries;
  final ValueChanged<String> onCountryChanged;
  final SortOption sortOption;
  final ValueChanged<SortOption> onSortChanged;

  const FilterChipsBar({
    super.key,
    required this.selectedCountry,
    required this.availableCountries,
    required this.onCountryChanged,
    required this.sortOption,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Country Dropdown
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: AppTheme.softShadow,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCountry,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: AppTheme.secondaryText),
                  isDense: true,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  items: [
                    const DropdownMenuItem(
                      value: 'All Countries',
                      child: Text('🌍 All Countries'),
                    ),
                    ...availableCountries.map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        )),
                  ],
                  onChanged: (val) {
                    if (val != null) onCountryChanged(val);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Sort Option Menu
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
              boxShadow: AppTheme.softShadow,
            ),
            child: PopupMenuButton<SortOption>(
              initialValue: sortOption,
              onSelected: onSortChanged,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort_rounded,
                      size: 17, color: AppTheme.secondaryText),
                  const SizedBox(width: 6),
                  Text(
                    sortOption.label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down_rounded,
                      size: 18, color: AppTheme.secondaryText),
                ],
              ),
              itemBuilder: (context) => SortOption.values
                  .map((opt) => PopupMenuItem(
                        value: opt,
                        child: Text(
                          opt.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: opt == sortOption
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: opt == sortOption
                                ? AppTheme.primary
                                : AppTheme.primaryText,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
