import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/country_data.dart';
import '../data/university_repository.dart';
import '../models/document_item.dart';
import '../models/university.dart';
import '../theme/app_theme.dart';

class AddEditUniversityScreen extends StatefulWidget {
  final UniversityRepository repository;
  final University? universityToEdit;

  const AddEditUniversityScreen({
    super.key,
    required this.repository,
    this.universityToEdit,
  });

  @override
  State<AddEditUniversityScreen> createState() =>
      _AddEditUniversityScreenState();
}

class _AddEditUniversityScreenState extends State<AddEditUniversityScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _programsController;
  late TextEditingController _scholarshipNameController;
  late TextEditingController _scholarshipCoverageController;
  late TextEditingController _languageReqController;
  late TextEditingController _greReqController;
  late TextEditingController _rankingController;
  late TextEditingController _portalUrlController;
  late TextEditingController _notesController;

  CountryInfo? _selectedCountryInfo;
  late String _selectedFlag;
  int _feeAmount = 0;

  late DateTime _selectedDeadline;
  late ApplicationStatus _selectedStatus;
  late ScholarshipType _selectedScholarshipType;
  late String _selectedDegreeLevel;

  bool get _isEditing => widget.universityToEdit != null;

  final List<String> _degreeOptions = [
    "Master's",
    "Bachelor's",
    'PhD / Doctorate',
    'Postgraduate Diploma',
  ];

  @override
  void initState() {
    super.initState();
    final u = widget.universityToEdit;

    _nameController = TextEditingController(text: u?.name ?? '');
    _countryController = TextEditingController(text: u?.country ?? '');
    _cityController = TextEditingController(text: u?.city ?? '');
    _programsController =
        TextEditingController(text: u?.programs.join(', ') ?? '');
    _scholarshipNameController =
        TextEditingController(text: u?.scholarshipName ?? '');
    _scholarshipCoverageController =
        TextEditingController(text: u?.scholarshipCoverage ?? '');
    _languageReqController =
        TextEditingController(text: u?.languageRequirement ?? 'IELTS 6.5');
    _greReqController =
        TextEditingController(text: u?.greRequirement ?? 'Not required');
    _rankingController = TextEditingController(text: u?.ranking ?? '');
    _portalUrlController = TextEditingController(text: u?.portalUrl ?? '');
    _notesController = TextEditingController(text: u?.notes ?? '');

    // Setup Country and Flag auto-detection
    final country = u?.country ?? '';
    _selectedCountryInfo = findCountryInfo(country);
    _selectedFlag = _selectedCountryInfo?.flag ?? u?.countryFlag ?? '🏛️';

    // Parse existing application fee amount
    final feeStr = u?.applicationFee ?? '0';
    final digitsMatch = RegExp(r'\d+').firstMatch(feeStr);
    if (digitsMatch != null) {
      _feeAmount = int.tryParse(digitsMatch.group(0)!) ?? 0;
    } else {
      _feeAmount = 0;
    }

    _selectedDeadline =
        u?.deadline ?? DateTime.now().add(const Duration(days: 60));
    _selectedStatus = u?.status ?? ApplicationStatus.wishlist;
    _selectedScholarshipType =
        u?.scholarshipType ?? ScholarshipType.fullyFunded;
    _selectedDegreeLevel = u?.degreeLevel ?? "Master's";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _programsController.dispose();
    _scholarshipNameController.dispose();
    _scholarshipCoverageController.dispose();
    _languageReqController.dispose();
    _greReqController.dispose();
    _rankingController.dispose();
    _portalUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _saveUniversity() async {
    if (!_formKey.currentState!.validate()) return;

    final programsList = _programsController.text
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    List<DocumentItem> docs;
    if (_isEditing) {
      docs = widget.universityToEdit!.documents;
    } else {
      docs = [
        DocumentItem(id: 'd1', title: 'Statement of Purpose (SOP)', isCompleted: false),
        DocumentItem(id: 'd2', title: 'CV / Resume (Europass / Standard)', isCompleted: false),
        DocumentItem(id: 'd3', title: 'Bachelor Transcripts & Degree', isCompleted: false),
        DocumentItem(id: 'd4', title: 'English Test Score (IELTS/TOEFL)', isCompleted: false),
        DocumentItem(id: 'd5', title: '2 Academic Recommendation Letters', isCompleted: false),
      ];
    }

    // Format application fee string with currency
    final currencySym = _selectedCountryInfo?.currencySymbol ?? '€';
    final applicationFeeStr = _feeAmount == 0
        ? '$currencySym 0 (Free)'
        : '$currencySym$_feeAmount';

    final university = University(
      id: widget.universityToEdit?.id ??
          'uni-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      country: _countryController.text.trim(),
      countryFlag: _selectedFlag,
      city: _cityController.text.trim(),
      programs: programsList.isEmpty ? ['Computer Science'] : programsList,
      degreeLevel: _selectedDegreeLevel,
      deadline: _selectedDeadline,
      status: _selectedStatus,
      scholarshipType: _selectedScholarshipType,
      scholarshipName: _scholarshipNameController.text.trim(),
      scholarshipCoverage: _scholarshipCoverageController.text.trim().isEmpty
          ? _selectedScholarshipType.description
          : _scholarshipCoverageController.text.trim(),
      applicationFee: applicationFeeStr,
      languageRequirement: _languageReqController.text.trim(),
      greRequirement: _greReqController.text.trim(),
      portalUrl: _portalUrlController.text.trim(),
      ranking: _rankingController.text.trim(),
      notes: _notesController.text.trim(),
      documents: docs,
    );

    if (_isEditing) {
      await widget.repository.updateUniversity(university);
    } else {
      await widget.repository.addUniversity(university);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? 'University updated successfully'
              : 'University added to your tracker! 🎓'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildFeeStepChip(String label, int targetValue) {
    final isCurrent = _feeAmount == targetValue;
    return InkWell(
      onTap: () {
        setState(() {
          _feeAmount = targetValue.clamp(0, 1000000);
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isCurrent ? AppTheme.primaryLight : AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCurrent ? AppTheme.primary : AppTheme.borderColor,
            width: isCurrent ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? AppTheme.primary : AppTheme.primaryText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit University' : 'Add University'),
        actions: [
          TextButton(
            onPressed: _saveUniversity,
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Basic Info Section
            _buildSectionCard(
              title: 'General Information',
              icon: Icons.account_balance_rounded,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'University Name *',
                    hintText: 'e.g. Oxford, TU Munich, Toronto',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'University name is required' : null,
                ),
                const SizedBox(height: 14),

                // Country Selector with Dropdown Autocomplete & Auto Flag
                Autocomplete<CountryInfo>(
                  initialValue: TextEditingValue(text: _countryController.text),
                  displayStringForOption: (CountryInfo option) => option.name,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return kSupportedCountries;
                    }
                    final q = textEditingValue.text.toLowerCase();
                    return kSupportedCountries.where((CountryInfo option) {
                      return option.name.toLowerCase().contains(q);
                    });
                  },
                  onSelected: (CountryInfo selection) {
                    setState(() {
                      _selectedCountryInfo = selection;
                      _countryController.text = selection.name;
                      _selectedFlag = selection.flag;
                    });
                  },
                  fieldViewBuilder: (context, fieldTextEditingController,
                      focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Country *',
                        hintText: 'Search country (e.g. Germany, UK, USA...)',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceMuted,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _selectedFlag,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 24,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Country is required' : null,
                      onChanged: (val) {
                        _countryController.text = val;
                        final matched = findCountryInfo(val);
                        if (matched != null && matched != _selectedCountryInfo) {
                          setState(() {
                            _selectedCountryInfo = matched;
                            _selectedFlag = matched.flag;
                          });
                        }
                      },
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 64,
                          constraints: const BoxConstraints(maxHeight: 260),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shrinkWrap: true,
                            itemCount: options.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, indent: 52),
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              final isSelected =
                                  _selectedCountryInfo?.name == option.name;
                              return ListTile(
                                dense: true,
                                selected: isSelected,
                                selectedTileColor: AppTheme.primaryLight,
                                leading: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceMuted,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(option.flag,
                                      style: const TextStyle(fontSize: 18)),
                                ),
                                title: Text(
                                  option.name,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    fontSize: 13.5,
                                    color: isSelected
                                        ? AppTheme.primary
                                        : AppTheme.primaryText,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceMuted,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${option.currencySymbol} (${option.currencyCode})',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.secondaryText,
                                    ),
                                  ),
                                ),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City / Campus',
                    hintText: 'e.g. Munich, Bavaria',
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _selectedDegreeLevel,
                  decoration: const InputDecoration(labelText: 'Degree Level'),
                  items: _degreeOptions
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDegreeLevel = val);
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _programsController,
                  decoration: const InputDecoration(
                    labelText: 'Programs of Interest',
                    hintText: 'Comma separated e.g. MSc CS, Data Science, AI',
                    helperText: 'Separate multiple programs with commas',
                  ),
                  maxLines: 2,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Status & Deadline Section
            _buildSectionCard(
              title: 'Application Status & Deadline',
              icon: Icons.event_available_rounded,
              children: [
                DropdownButtonFormField<ApplicationStatus>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(labelText: 'Application Status'),
                  items: ApplicationStatus.values
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                Text(s.label,
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                Text('(${s.description})',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppTheme.secondaryText)),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
                ),
                const SizedBox(height: 14),
                // Deadline Picker Box
                InkWell(
                  onTap: _pickDeadline,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Application Deadline',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE, MMMM dd, yyyy')
                                  .format(_selectedDeadline),
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryText,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.calendar_month_rounded,
                              color: AppTheme.primary, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Application Fee: Non-editable freeform text; controlled stepper with country currency
                _buildApplicationFeeControl(),
              ],
            ),

            const SizedBox(height: 16),

            // Scholarship & Financial Aid
            _buildSectionCard(
              title: 'Scholarship & Financial Aid',
              icon: Icons.auto_awesome_rounded,
              children: [
                DropdownButtonFormField<ScholarshipType>(
                  value: _selectedScholarshipType,
                  decoration: const InputDecoration(labelText: 'Funding Type'),
                  items: ScholarshipType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.label,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedScholarshipType = val);
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _scholarshipNameController,
                  decoration: const InputDecoration(
                    labelText: 'Scholarship Name',
                    hintText: 'e.g. DAAD, Fulbright, Clarendon, DSU Italy',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _scholarshipCoverageController,
                  decoration: const InputDecoration(
                    labelText: 'Coverage Details',
                    hintText:
                        'e.g. 100% Tuition waiver + €934/month stipend + Travel',
                  ),
                  maxLines: 2,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Requirements & Ranking
            _buildSectionCard(
              title: 'Requirements & Rankings',
              icon: Icons.verified_user_outlined,
              children: [
                TextFormField(
                  controller: _languageReqController,
                  decoration: const InputDecoration(
                    labelText: 'Language Requirement',
                    hintText: 'e.g. IELTS 7.0, TOEFL 100, Duolingo 125',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _greReqController,
                  decoration: const InputDecoration(
                    labelText: 'GRE / Standardized Test',
                    hintText: 'e.g. Not required, GRE 320+',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _rankingController,
                  decoration: const InputDecoration(
                    labelText: 'Global / Subject Ranking',
                    hintText: 'e.g. #28 QS World, #15 Engineering',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _portalUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Application Portal URL',
                    hintText: 'https://apply.university.edu',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Personal Notes & Strategy',
                    hintText: 'Supervisor contact, key essay questions, special tips',
                  ),
                  maxLines: 3,
                ),
              ],
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveUniversity,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? 'Update University Details' : 'Add University',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationFeeControl() {
    final countrySelected = _countryController.text.trim().isNotEmpty;
    final info = _selectedCountryInfo ??
        findCountryInfo(_countryController.text.trim()) ??
        const CountryInfo(
            name: 'Global', flag: '🌐', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10);

    if (!countrySelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock_outline_rounded,
                size: 18, color: AppTheme.secondaryText),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Select country above to set application fee & currency',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final currencySym = info.currencySymbol;
    final step = info.defaultStep;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      size: 17, color: AppTheme.secondaryText),
                  const SizedBox(width: 6),
                  Text(
                    'Application Fee (${info.currencyCode})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ],
              ),
              if (_feeAmount == 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: AppTheme.successBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.success.withOpacity(0.3), width: 0.8),
                  ),
                  child: const Text(
                    'FREE / WAIVED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.success,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Stepper: Minus Button + Fee Display + Plus Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minus Button
                Material(
                  color: _feeAmount > 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: _feeAmount > 0
                        ? () {
                            setState(() {
                              _feeAmount = (_feeAmount - step).clamp(0, 1000000);
                            });
                          }
                        : null,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: _feeAmount > 0
                            ? Border.all(color: AppTheme.borderColor)
                            : null,
                      ),
                      child: Icon(
                        Icons.remove_rounded,
                        size: 20,
                        color: _feeAmount > 0
                            ? AppTheme.primaryText
                            : AppTheme.mutedText,
                      ),
                    ),
                  ),
                ),

                // Amount Text Display (non-editable text)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _feeAmount == 0
                          ? '$currencySym 0'
                          : '$currencySym $_feeAmount',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _feeAmount == 0
                            ? AppTheme.success
                            : AppTheme.primaryText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      _feeAmount == 0 ? 'No Fee (Free)' : info.currencyCode,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Plus Button
                Material(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _feeAmount += step;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Quick Presets
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeeStepChip('Free ($currencySym 0)', 0),
              const SizedBox(width: 8),
              _buildFeeStepChip('+$currencySym$step', _feeAmount + step),
              const SizedBox(width: 8),
              _buildFeeStepChip(
                  '+$currencySym${step * 5}', _feeAmount + (step * 5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
              Icon(icon, size: 17, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
