// 📁 lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb; // Safe prefix mapping
import 'package:provider/provider.dart';

// Update these strings to match your exact pubspec.yaml project name
import 'providers/language_app_state.dart';
import 'providers/location_app_state.dart';
import 'routing/app_router.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 FIX FOR FLUTTER WEB EMULATOR INITIALIZATION
  // We pass a mock FirebaseOptions configuration object to satisfy Chrome
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "mock-api-key-for-emulator-testing",
      appId: "1:1234567890:web:abcdef123456",
      messagingSenderId: "1234567890",
      projectId:
          "vicinum-club-local", // Put your desired firebase project ID here
    ),
  );

  // 🧪 CONNECT TO LOCAL FIREBASE AUTH EMULATOR
  try {
    // Uses the prefixed 'fb' alias to completely avoid naming collisions
    await fb.FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
  } catch (e) {
    debugPrint('Emulator fallback active or already running: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => LocationAppState()),
        ChangeNotifierProvider(create: (_) => LanguageAppState()),
      ],
      child: const MyApp(),
    ),
  );
}

// 🏛️ RESTORED COMPONENT WRAPPER CLASS
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vicinum Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      // Binds the application to your GoRouter declaration engine setup
      routerConfig: AppRouter.router,
    );
  }
}
