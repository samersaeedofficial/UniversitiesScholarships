import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/university_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for seamless light mode aesthetics
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final repository = UniversityRepository();

  runApp(ScholarTrackApp(repository: repository));
}

class ScholarTrackApp extends StatelessWidget {
  final UniversityRepository repository;

  const ScholarTrackApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScholarTrack - Universities & Scholarships',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeScreen(repository: repository),
    );
  }
}
