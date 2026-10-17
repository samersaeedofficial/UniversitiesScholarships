import 'document_item.dart';

enum ApplicationStatus {
  wishlist('Wishlist / Plan', 'Not yet applied'),
  inProgress('In Progress', 'Preparing documents'),
  applied('Applied', 'Submitted & under review'),
  interview('Interview', 'Interview round'),
  accepted('Accepted 🎉', 'Offer received'),
  rejected('Rejected', 'Better luck next time');

  final String label;
  final String description;

  const ApplicationStatus(this.label, this.description);

  static ApplicationStatus fromString(String val) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.name == val,
      orElse: () => ApplicationStatus.wishlist,
    );
  }
}

enum ScholarshipType {
  fullyFunded('Fully Funded', '100% Tuition + Living Stipend'),
  tuitionWaiver('Tuition Waiver', 'Free Tuition Fees'),
  partial('Partial Scholarship', 'Partial Tuition or Fixed Grant'),
  needBased('Need-Based Aid', 'Based on Financial Need'),
  externalOnly('External Grant', 'Erasmus / DAAD / Fulbright'),
  none('Self Funded', 'No financial aid available');

  final String label;
  final String description;

  const ScholarshipType(this.label, this.description);

  static ScholarshipType fromString(String val) {
    return ScholarshipType.values.firstWhere(
      (e) => e.name == val,
      orElse: () => ScholarshipType.none,
    );
  }
}

class University {
  final String id;
  final String name;
  final String country;
  final String countryFlag;
  final String city;
  final List<String> programs;
  final String degreeLevel;
  final DateTime deadline;
  final ApplicationStatus status;
  final ScholarshipType scholarshipType;
  final String scholarshipName;
  final String scholarshipCoverage;
  final String applicationFee;
  final String languageRequirement;
  final String greRequirement;
  final String portalUrl;
  final String ranking;
  final String notes;
  final List<DocumentItem> documents;

  University({
    required this.id,
    required this.name,
    required this.country,
    required this.countryFlag,
    required this.city,
    required this.programs,
    required this.degreeLevel,
    required this.deadline,
    required this.status,
    required this.scholarshipType,
    required this.scholarshipName,
    required this.scholarshipCoverage,
    required this.applicationFee,
    required this.languageRequirement,
    this.greRequirement = 'Not required',
    this.portalUrl = '',
    this.ranking = '',
    this.notes = '',
    required this.documents,
  });

  bool get isApplied => status == ApplicationStatus.applied ||
      status == ApplicationStatus.interview ||
      status == ApplicationStatus.accepted;

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    return target.difference(today).inDays;
  }

  int get completedDocumentsCount =>
      documents.where((d) => d.isCompleted).length;

  double get documentCompletionRate =>
      documents.isEmpty ? 0.0 : completedDocumentsCount / documents.length;

  University copyWith({
    String? id,
    String? name,
    String? country,
    String? countryFlag,
    String? city,
    List<String>? programs,
    String? degreeLevel,
    DateTime? deadline,
    ApplicationStatus? status,
    ScholarshipType? scholarshipType,
    String? scholarshipName,
    String? scholarshipCoverage,
    String? applicationFee,
    String? languageRequirement,
    String? greRequirement,
    String? portalUrl,
    String? ranking,
    String? notes,
    List<DocumentItem>? documents,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      countryFlag: countryFlag ?? this.countryFlag,
      city: city ?? this.city,
      programs: programs ?? this.programs,
      degreeLevel: degreeLevel ?? this.degreeLevel,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      scholarshipType: scholarshipType ?? this.scholarshipType,
      scholarshipName: scholarshipName ?? this.scholarshipName,
      scholarshipCoverage: scholarshipCoverage ?? this.scholarshipCoverage,
      applicationFee: applicationFee ?? this.applicationFee,
      languageRequirement: languageRequirement ?? this.languageRequirement,
      greRequirement: greRequirement ?? this.greRequirement,
      portalUrl: portalUrl ?? this.portalUrl,
      ranking: ranking ?? this.ranking,
      notes: notes ?? this.notes,
      documents: documents ?? this.documents,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
        'countryFlag': countryFlag,
        'city': city,
        'programs': programs,
        'degreeLevel': degreeLevel,
        'deadline': deadline.toIso8601String(),
        'status': status.name,
        'scholarshipType': scholarshipType.name,
        'scholarshipName': scholarshipName,
        'scholarshipCoverage': scholarshipCoverage,
        'applicationFee': applicationFee,
        'languageRequirement': languageRequirement,
        'greRequirement': greRequirement,
        'portalUrl': portalUrl,
        'ranking': ranking,
        'notes': notes,
        'documents': documents.map((d) => d.toJson()).toList(),
      };

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      countryFlag: json['countryFlag'] as String? ?? '🏛️',
      city: json['city'] as String,
      programs: (json['programs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      degreeLevel: json['degreeLevel'] as String? ?? "Master's",
      deadline: DateTime.parse(json['deadline'] as String),
      status: ApplicationStatus.fromString(json['status'] as String? ?? 'wishlist'),
      scholarshipType: ScholarshipType.fromString(
          json['scholarshipType'] as String? ?? 'none'),
      scholarshipName: json['scholarshipName'] as String? ?? '',
      scholarshipCoverage: json['scholarshipCoverage'] as String? ?? '',
      applicationFee: json['applicationFee'] as String? ?? 'Free',
      languageRequirement: json['languageRequirement'] as String? ?? 'N/A',
      greRequirement: json['greRequirement'] as String? ?? 'Not required',
      portalUrl: json['portalUrl'] as String? ?? '',
      ranking: json['ranking'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((d) => DocumentItem.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
