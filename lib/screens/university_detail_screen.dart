import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/university_repository.dart';
import '../models/university.dart';
import '../theme/app_theme.dart';
import '../widgets/deadline_badge.dart';
import '../widgets/scholarship_badge.dart';
import '../widgets/status_badge.dart';
import 'add_edit_university_screen.dart';

class UniversityDetailScreen extends StatefulWidget {
  final String universityId;
  final UniversityRepository repository;

  const UniversityDetailScreen({
    super.key,
    required this.universityId,
    required this.repository,
  });

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  final TextEditingController _newDocController = TextEditingController();

  University? get _university {
    try {
      return widget.repository.universities
          .firstWhere((u) => u.id == widget.universityId);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _newDocController.dispose();
    super.dispose();
  }

  void _showAddDocumentDialog() {
    _newDocController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Add Document Requirement',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: _newDocController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Portfolio PDF, Research Proposal, GRE',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _newDocController.text.trim();
              if (text.isNotEmpty) {
                widget.repository.addDocumentToUniversity(
                    widget.universityId, text);
                Navigator.pop(ctx);
                setState(() {});
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Remove University?'),
        content: Text(
          'Are you sure you want to remove "${_university?.name}" from your tracker?',
          style: const TextStyle(color: AppTheme.secondaryText, fontSize: 14),
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
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              await widget.repository.deleteUniversity(widget.universityId);
              if (mounted) {
                Navigator.pop(context); // Return to home
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('University removed successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uni = _university;

    if (uni == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('University not found')),
      );
    }

    final docsTotal = uni.documents.length;
    final docsDone = uni.completedDocumentsCount;
    final docsPercent = uni.documentCompletionRate;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(uni.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit University',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditUniversityScreen(
                    repository: widget.repository,
                    universityToEdit: uni,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppTheme.danger),
            tooltip: 'Delete',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // University Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceMuted,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Text(uni.countryFlag,
                            style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              uni.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryText,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${uni.city}, ${uni.country}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  // Status & Deadline Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'APPLICATION STATUS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondaryText,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StatusBadge(
                            status: uni.status,
                            isInteractive: true,
                            onStatusChanged: (newStatus) {
                              widget.repository
                                  .updateStatus(uni.id, newStatus);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'DEADLINE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondaryText,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DeadlineBadge(deadline: uni.deadline, showDate: true),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Degree Level',
                    value: uni.degreeLevel,
                    icon: Icons.school_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoCard(
                    title: 'Application Fee',
                    value: uni.applicationFee,
                    icon: Icons.credit_card_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoCard(
                    title: 'QS Ranking',
                    value: uni.ranking.isNotEmpty ? uni.ranking : 'Top Ranked',
                    icon: Icons.emoji_events_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Financial Aid & Scholarships
            _buildSectionHeader('Financial Aid & Scholarships', Icons.auto_awesome_rounded),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ScholarshipBadge(type: uni.scholarshipType),
                      const Spacer(),
                      if (uni.scholarshipType == ScholarshipType.fullyFunded)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.successBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '100% Coverage',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.success,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (uni.scholarshipName.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      uni.scholarshipName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    uni.scholarshipCoverage,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppTheme.secondaryText,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Programs of Interest
            _buildSectionHeader('Target Programs', Icons.menu_book_rounded),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (uni.programs.isEmpty)
                    const Text('No specific programs listed yet',
                        style: TextStyle(color: AppTheme.secondaryText))
                  else
                    ...uni.programs.asMap().entries.map(
                          (entry) => Padding(
                            padding: EdgeInsets.only(
                                bottom: entry.key == uni.programs.length - 1
                                    ? 0
                                    : 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.bookmark_added_rounded,
                                      size: 15, color: AppTheme.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Admission Requirements
            _buildSectionHeader('Admission Requirements', Icons.verified_user_outlined),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  _buildRequirementRow(
                    label: 'Language Proficiency',
                    value: uni.languageRequirement,
                    icon: Icons.language_rounded,
                  ),
                  const Divider(height: 20),
                  _buildRequirementRow(
                    label: 'GRE / GMAT',
                    value: uni.greRequirement,
                    icon: Icons.analytics_outlined,
                  ),
                  if (uni.portalUrl.isNotEmpty) ...[
                    const Divider(height: 20),
                    _buildRequirementRow(
                      label: 'Application Portal',
                      value: uni.portalUrl,
                      icon: Icons.open_in_new_rounded,
                      isUrl: true,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Document Preparation Checklist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(
                  'Application Checklist ($docsDone/$docsTotal)',
                  Icons.checklist_rounded,
                ),
                TextButton.icon(
                  onPressed: _showAddDocumentDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Item', style: TextStyle(fontSize: 12.5)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: docsPercent,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              docsPercent == 1.0
                                  ? AppTheme.success
                                  : AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(docsPercent * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (uni.documents.isEmpty)
                    const Text('No checklist items yet. Tap "+ Add Item" above.')
                  else
                    ...uni.documents.map((doc) => InkWell(
                          onTap: () {
                            widget.repository
                                .toggleDocument(uni.id, doc.id);
                            setState(() {});
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: doc.isCompleted,
                                  activeColor: AppTheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  onChanged: (_) {
                                    widget.repository
                                        .toggleDocument(uni.id, doc.id);
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    doc.title,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: doc.isCompleted
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                      color: doc.isCompleted
                                          ? AppTheme.secondaryText
                                          : AppTheme.primaryText,
                                      decoration: doc.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),

            if (uni.notes.isNotEmpty) ...[
              const SizedBox(height: 18),
              _buildSectionHeader('Notes & Strategy', Icons.edit_note_rounded),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.borderColor),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Text(
                  uni.notes,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppTheme.primaryText,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppTheme.borderColor)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final nextStatus = uni.isApplied
                        ? ApplicationStatus.wishlist
                        : ApplicationStatus.applied;
                    widget.repository.updateStatus(uni.id, nextStatus);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(uni.isApplied
                            ? 'Marked as Not Applied'
                            : 'Marked as Applied! 🎉'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: Icon(
                    uni.isApplied
                        ? Icons.undo_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 18,
                  ),
                  label: Text(
                    uni.isApplied ? 'Unmark Applied' : 'Mark as Applied',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: uni.isApplied
                        ? AppTheme.secondaryText
                        : AppTheme.primary,
                    side: BorderSide(
                        color: uni.isApplied
                            ? AppTheme.borderColor
                            : AppTheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditUniversityScreen(
                          repository: widget.repository,
                          universityToEdit: uni,
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryText,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.secondaryText),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow({
    required String label,
    required String value,
    required IconData icon,
    bool isUrl = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppTheme.secondaryText),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryText,
                ),
              ),
              const SizedBox(height: 2),
              isUrl
                  ? InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Portal link copied to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
