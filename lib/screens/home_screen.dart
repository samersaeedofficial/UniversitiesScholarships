import 'package:flutter/material.dart';
import '../data/university_repository.dart';
import '../models/university.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/university_card.dart';
import 'add_edit_university_screen.dart';
import 'university_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final UniversityRepository repository;

  const HomeScreen({
    super.key,
    required this.repository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeCategoryFilter = 'all'; // all, applied, wishlist, fully_funded, urgent
  String _selectedCountry = 'All Countries';
  SortOption _currentSort = SortOption.soonestDeadline;

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_onRepoUpdate);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    widget.repository.removeListener(_onRepoUpdate);
    _searchController.dispose();
    super.dispose();
  }

  void _onRepoUpdate() {
    if (mounted) setState(() {});
  }

  List<String> get _availableCountries {
    final set = <String>{};
    for (final u in widget.repository.universities) {
      if (u.country.isNotEmpty) {
        set.add('${u.countryFlag} ${u.country}');
      }
    }
    final list = set.toList()..sort();
    return list;
  }

  List<University> get _filteredUniversities {
    var list = List<University>.from(widget.repository.universities);

    // 1. Text Search Query
    if (_searchQuery.isNotEmpty) {
      list = list.where((u) {
        final matchName = u.name.toLowerCase().contains(_searchQuery);
        final matchCountry = u.country.toLowerCase().contains(_searchQuery);
        final matchCity = u.city.toLowerCase().contains(_searchQuery);
        final matchScholarship =
            u.scholarshipName.toLowerCase().contains(_searchQuery);
        final matchProgram = u.programs
            .any((p) => p.toLowerCase().contains(_searchQuery));
        return matchName ||
            matchCountry ||
            matchCity ||
            matchScholarship ||
            matchProgram;
      }).toList();
    }

    // 2. Category Filter
    switch (_activeCategoryFilter) {
      case 'applied':
        list = list.where((u) => u.isApplied).toList();
        break;
      case 'wishlist':
        list = list
            .where((u) =>
                u.status == ApplicationStatus.wishlist ||
                u.status == ApplicationStatus.inProgress)
            .toList();
        break;
      case 'fully_funded':
        list = list
            .where((u) => u.scholarshipType == ScholarshipType.fullyFunded)
            .toList();
        break;
      case 'urgent':
        list = list
            .where((u) => u.daysRemaining >= 0 && u.daysRemaining <= 30)
            .toList();
        break;
      case 'all':
      default:
        break;
    }

    // 3. Country Filter
    if (_selectedCountry != 'All Countries') {
      list = list.where((u) {
        return '${u.countryFlag} ${u.country}' == _selectedCountry ||
            u.country == _selectedCountry;
      }).toList();
    }

    // 4. Sorting
    switch (_currentSort) {
      case SortOption.soonestDeadline:
        list.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case SortOption.latestDeadline:
        list.sort((a, b) => b.deadline.compareTo(a.deadline));
        break;
      case SortOption.nameAsc:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.status:
        list.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
    }

    return list;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _activeCategoryFilter = 'all';
      _selectedCountry = 'All Countries';
    });
  }

  void _confirmDelete(University uni) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete University?'),
        content: Text(
          'Are you sure you want to remove "${uni.name}"?',
          style: const TextStyle(fontSize: 14, color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.repository.deleteUniversity(uni.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${uni.name} removed'),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.amber,
                    onPressed: () => widget.repository.addUniversity(uni),
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Reset to Initial Mock Data?'),
        content: const Text(
          'This will reset your list to the original top global universities (Oxford, TUM, KAIST, PoliMi, ETH, NUS, KTH).',
          style: TextStyle(fontSize: 14, color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
            ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.repository.resetToMockData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reset to original sample data!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Reset Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final universities = _filteredUniversities;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1050;
    final isTablet = screenWidth >= 650 && screenWidth < 1050;
    final int crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'ScholarTrack',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryText,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '2026/27',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Universities & Scholarships Tracker',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Mock Data',
            onPressed: _showResetConfirmation,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: widget.repository.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search university, country, program, scholarship...',
                          hintStyle: const TextStyle(
                              color: AppTheme.mutedText, fontSize: 13.5),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppTheme.secondaryText, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 18, color: AppTheme.secondaryText),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Dashboard Statistics
                SliverToBoxAdapter(
                  child: DashboardStatsBanner(
                    repository: widget.repository,
                    activeFilter: _activeCategoryFilter,
                    onFilterSelected: (filter) {
                      setState(() {
                        if (_activeCategoryFilter == filter) {
                          _activeCategoryFilter = 'all';
                        } else {
                          _activeCategoryFilter = filter;
                        }
                      });
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 4)),

                // Filters & Sorting Controls
                SliverToBoxAdapter(
                  child: FilterChipsBar(
                    selectedCountry: _selectedCountry,
                    availableCountries: _availableCountries,
                    onCountryChanged: (c) =>
                        setState(() => _selectedCountry = c),
                    sortOption: _currentSort,
                    onSortChanged: (s) => setState(() => _currentSort = s),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Results Count Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${universities.length} ${universities.length == 1 ? "university" : "universities"}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty ||
                            _activeCategoryFilter != 'all' ||
                            _selectedCountry != 'All Countries')
                          InkWell(
                            onTap: _clearFilters,
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Text(
                                'Clear all',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 6)),

                // Universities List
                if (universities.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateView(
                      title: 'No Universities Found',
                      description: _searchQuery.isNotEmpty ||
                              _activeCategoryFilter != 'all' ||
                              _selectedCountry != 'All Countries'
                          ? 'No results match your active search or filters. Try adjusting your query.'
                          : 'You haven\'t added any universities yet. Tap the button below to add your first one!',
                      actionLabel: _searchQuery.isNotEmpty ||
                              _activeCategoryFilter != 'all' ||
                              _selectedCountry != 'All Countries'
                          ? 'Reset Filters'
                          : 'Add University',
                      onAction: _searchQuery.isNotEmpty ||
                              _activeCategoryFilter != 'all' ||
                              _selectedCountry != 'All Countries'
                          ? _clearFilters
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditUniversityScreen(
                                    repository: widget.repository,
                                  ),
                                ),
                              );
                            },
                    ),
                  )
                else if (crossAxisCount > 1)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 118,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final uni = universities[index];
                          return UniversityCard(
                            university: uni,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UniversityDetailScreen(
                                    universityId: uni.id,
                                    repository: widget.repository,
                                  ),
                                ),
                              );
                            },
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditUniversityScreen(
                                    repository: widget.repository,
                                    universityToEdit: uni,
                                  ),
                                ),
                              );
                            },
                            onDelete: () => _confirmDelete(uni),
                            onStatusChanged: (newStatus) {
                              widget.repository.updateStatus(uni.id, newStatus);
                            },
                            onToggleApplied: () {
                              final nextStatus = uni.isApplied
                                  ? ApplicationStatus.wishlist
                                  : ApplicationStatus.applied;
                              widget.repository.updateStatus(uni.id, nextStatus);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(uni.isApplied
                                      ? 'Marked as Not Applied'
                                      : 'Marked as Applied! 🎉'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        },
                        childCount: universities.length,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final uni = universities[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: UniversityCard(
                              university: uni,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UniversityDetailScreen(
                                      universityId: uni.id,
                                      repository: widget.repository,
                                    ),
                                  ),
                                );
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditUniversityScreen(
                                      repository: widget.repository,
                                      universityToEdit: uni,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () => _confirmDelete(uni),
                              onStatusChanged: (newStatus) {
                                widget.repository.updateStatus(uni.id, newStatus);
                              },
                              onToggleApplied: () {
                                final nextStatus = uni.isApplied
                                    ? ApplicationStatus.wishlist
                                    : ApplicationStatus.applied;
                                widget.repository.updateStatus(uni.id, nextStatus);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(uni.isApplied
                                        ? 'Marked as Not Applied'
                                        : 'Marked as Applied! 🎉'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: universities.length,
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditUniversityScreen(
                repository: widget.repository,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'Add University',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2),
        ),
      ),
    );
  }
}
