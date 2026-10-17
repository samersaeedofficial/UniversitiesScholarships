import '../models/document_item.dart';
import '../models/university.dart';

/// Hardcoded initial university & scholarship data
/// Sourced directly from official Türkiye Scholarships portal:
/// https://www.turkiyeburslari.gov.tr/scholarshipsprocess
final List<University> initialMockUniversities = [
  University(
    id: 'uni-turkiye-burslari',
    name: 'Türkiye Scholarships (Türkiye Bursları)',
    country: 'Turkey (Türkiye)',
    countryFlag: '🇹🇷',
    city: 'Ankara & Istanbul',
    programs: [
      'M.Sc. / B.Sc. Computer Engineering & Artificial Intelligence',
      'M.Sc. / B.Sc. Software Engineering & Data Science',
      'Medicine, Dentistry & Pharmacy (Health Sciences)',
      'Electrical & Electronics Engineering',
      'Business Administration & Economics',
      'International Relations & Public Policy',
      'Mechanical & Aerospace Engineering',
    ],
    degreeLevel: "Bachelor's / Master's / PhD",
    // Next annual application cycle deadline: February 20
    deadline: DateTime(
      DateTime.now().month <= 2 && DateTime.now().day <= 20
          ? DateTime.now().year
          : DateTime.now().year + 1,
      2,
      20,
      23,
      59,
    ),
    status: ApplicationStatus.wishlist,
    scholarshipType: ScholarshipType.fullyFunded,
    scholarshipName: 'Türkiye Bursları Full Government Scholarship (YTB)',
    scholarshipCoverage:
        '100% Full Tuition Waiver + Free Dormitory Accommodation + Monthly Living Stipend + General Health Insurance (GSS) + 1-Year Free Turkish Language Course (TÖMER) + Round-trip Flight Tickets',
    applicationFee: '₺0 (Free of Charge - Zero Application Fee)',
    languageRequirement:
        'No Turkish required initially (1-Year Free TÖMER Language Course provided) | English programs require TOEFL iBT',
    greRequirement:
        'Not required for general application (Some top engineering faculties recommend GRE/ALES)',
    portalUrl: 'https://www.turkiyeburslari.gov.tr/scholarshipsprocess',
    ranking: '#1 Government Scholarship in Türkiye (Top 12 Partner Universities)',
    notes:
        'Official Turkish Government scholarship program managed by YTB. Students apply online via the TBBS portal (tbbs.turkiyeburslari.gov.tr) and can select up to 12 university and department preferences. Admission covers placement into top state & private universities (e.g. METU, Boğaziçi, ITU, Koç, Sabancı, Bilkent). Academic criteria: Minimum 70% for Bachelor’s, 75% for Master’s/PhD, 90% for Health Sciences. Fully covers tuition, housing, living stipend, health insurance, and international flights.',
    documents: [
      DocumentItem(id: 'tb-1', title: 'Valid Passport / National ID Card', isCompleted: true),
      DocumentItem(id: 'tb-2', title: 'Official Academic Transcripts (GPA > 75%)', isCompleted: true),
      DocumentItem(id: 'tb-3', title: 'Graduation Diploma / Degree Certificate', isCompleted: true),
      DocumentItem(id: 'tb-4', title: 'Letter of Intent & Statement of Purpose (TBBS form)', isCompleted: false),
      DocumentItem(id: 'tb-5', title: '2 Academic Recommendation Letters', isCompleted: false),
      DocumentItem(id: 'tb-6', title: 'Europass CV / Resume', isCompleted: false),
      DocumentItem(id: 'tb-7', title: 'Academic Achievements & Extracurricular Certificates', isCompleted: false),
      DocumentItem(id: 'tb-8', title: 'Research Proposal (for Master’s / PhD applicants)', isCompleted: false),
    ],
  ),
];
