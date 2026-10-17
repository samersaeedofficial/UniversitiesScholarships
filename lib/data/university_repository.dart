import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document_item.dart';
import '../models/university.dart';
import 'mock_universities.dart';

class UniversityRepository extends ChangeNotifier {
  static const String _storageKey = 'tracked_universities_v2';
  static const String _dataVersionKey = 'app_data_version';
  static const String _currentVersion = 'turkiye_burslari_v1';
  List<University> _universities = [];
  bool _isLoading = true;

  List<University> get universities => List.unmodifiable(_universities);
  bool get isLoading => _isLoading;

  UniversityRepository() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentVer = prefs.getString(_dataVersionKey);
      final rawJson = prefs.getString(_storageKey);

      // If data version is old or no data stored yet, migrate to fresh hardcoded data
      if (currentVer != _currentVersion || rawJson == null || rawJson.isEmpty) {
        // Clear previous stale storage
        await prefs.remove('tracked_universities_v1');
        _universities = List.from(initialMockUniversities);
        await prefs.setString(_dataVersionKey, _currentVersion);
        await _saveToStorage();
      } else {
        final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
        _universities = decoded
            .map((item) => University.fromJson(item as Map<String, dynamic>))
            .toList();
        if (_universities.isEmpty) {
          _universities = List.from(initialMockUniversities);
          await _saveToStorage();
        }
      }
    } catch (e) {
      debugPrint('Error loading universities from storage: $e');
      _universities = List.from(initialMockUniversities);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_universities.map((u) => u.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Error saving universities to storage: $e');
    }
  }

  // Add university
  Future<void> addUniversity(University university) async {
    _universities.insert(0, university);
    notifyListeners();
    await _saveToStorage();
  }

  // Update existing university
  Future<void> updateUniversity(University updated) async {
    final index = _universities.indexWhere((u) => u.id == updated.id);
    if (index != -1) {
      _universities[index] = updated;
      notifyListeners();
      await _saveToStorage();
    }
  }

  // Delete university
  Future<void> deleteUniversity(String id) async {
    _universities.removeWhere((u) => u.id == id);
    notifyListeners();
    await _saveToStorage();
  }

  // Quick toggle status
  Future<void> updateStatus(String id, ApplicationStatus newStatus) async {
    final index = _universities.indexWhere((u) => u.id == id);
    if (index != -1) {
      _universities[index] = _universities[index].copyWith(status: newStatus);
      notifyListeners();
      await _saveToStorage();
    }
  }

  // Toggle document completed
  Future<void> toggleDocument(String uniId, String docId) async {
    final index = _universities.indexWhere((u) => u.id == uniId);
    if (index != -1) {
      final uni = _universities[index];
      final updatedDocs = uni.documents.map((d) {
        if (d.id == docId) {
          return d.copyWith(isCompleted: !d.isCompleted);
        }
        return d;
      }).toList();

      _universities[index] = uni.copyWith(documents: updatedDocs);
      notifyListeners();
      await _saveToStorage();
    }
  }

  // Add document to university
  Future<void> addDocumentToUniversity(String uniId, String title) async {
    final index = _universities.indexWhere((u) => u.id == uniId);
    if (index != -1) {
      final uni = _universities[index];
      final newDoc = DocumentItem(
        id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        isCompleted: false,
      );
      final updatedDocs = List<DocumentItem>.from(uni.documents)..add(newDoc);
      _universities[index] = uni.copyWith(documents: updatedDocs);
      notifyListeners();
      await _saveToStorage();
    }
  }

  // Reset to initial mock data
  Future<void> resetToMockData() async {
    _universities = List.from(initialMockUniversities);
    notifyListeners();
    await _saveToStorage();
  }

  // Statistics helpers
  int get totalCount => _universities.length;

  int get appliedCount => _universities.where((u) => u.isApplied).length;

  int get wishlistCount =>
      _universities.where((u) => u.status == ApplicationStatus.wishlist).length;

  int get fullyFundedCount => _universities
      .where((u) => u.scholarshipType == ScholarshipType.fullyFunded)
      .length;

  int get urgentDeadlinesCount =>
      _universities.where((u) => u.daysRemaining >= 0 && u.daysRemaining <= 30).length;
}
