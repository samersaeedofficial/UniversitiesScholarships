import 'package:flutter_test/flutter_test.dart';
import 'package:scholarships_tracker/data/university_repository.dart';
import 'package:scholarships_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ScholarTrackApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final repo = UniversityRepository();

    await tester.pumpWidget(ScholarTrackApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.text('ScholarTrack'), findsOneWidget);
    expect(find.text('Add University'), findsOneWidget);
  });
}
