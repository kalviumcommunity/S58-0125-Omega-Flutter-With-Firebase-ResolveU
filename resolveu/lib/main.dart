import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/onboarding_screen.dart';
import 'theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  print('Firebase initialized successfully');
  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeManager(),
      builder: (context, child) {
        return MaterialApp(
          title: 'ResolveU',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeManager().themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF), // Vibrant Indigo
              primary: const Color(0xFF6C63FF),
              secondary: const Color(0xFFFF6584), // Coral
              tertiary: const Color(0xFF00B8D9), // Teal
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Off-white/pale blue hint
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 4, // Soft shadow needs elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.black.withOpacity(0.2), // Lighter shadow for diffuse look (elevation adds intensity)
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFFF6584), // Coral
              foregroundColor: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color.fromARGB(255, 27, 38, 44), // Sunset Dark Base
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color.fromARGB(255, 255, 134, 91), // Sunset Orange
              onPrimary: Color.fromARGB(255, 22, 6, 3),   // Sunset Orange Logic
              secondary: Color.fromARGB(255, 253, 111, 156), // Sunset Pink
              onSecondary: Color.fromARGB(255, 22, 4, 9),
              tertiary: Color.fromARGB(255, 179, 135, 250), // Sunset Purple
              onTertiary: Color.fromARGB(255, 12, 6, 21),
              error: Color(0xFFCF6679),
              onError: Colors.black,
              surface: Color.fromARGB(255, 27, 38, 44), // Sunset Dark Base
              onSurface: Color.fromARGB(255, 148, 160, 169), // Sunset Text Grey
            ),
            useMaterial3: true,
            cardTheme: CardThemeData(
              color: const Color.fromARGB(255, 35, 48, 56), // Slightly lighter than background
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.black.withOpacity(0.4),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              foregroundColor: Color.fromARGB(255, 148, 160, 169), // Text Grey
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromARGB(255, 253, 111, 156), // Sunset Pink
              foregroundColor: Color.fromARGB(255, 22, 4, 9),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color.fromARGB(255, 20, 28, 33),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color.fromARGB(255, 148, 160, 169)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color.fromARGB(100, 148, 160, 169)),
              ),
              labelStyle: TextStyle(color: Color.fromARGB(255, 148, 160, 169)),
              hintStyle: TextStyle(color: Color.fromARGB(150, 148, 160, 169)),
            ),
          ),
          home: seenOnboarding ? const LoginPage() : const OnboardingScreen(),
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Container(
                    color: Colors.grey[900], // Dark background for desktop view to highlight mobile frame
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: child,
                      ),
                    ),
                  );
                }
                return child!;
              },
            );
          },
        );
      },
    );
  }
}

