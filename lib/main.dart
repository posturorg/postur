import 'package:flutter/services.dart';

import '/pages/auth_page.dart';
import '/src/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Keep app from flipping with phone orientation
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      title: 'Postur',
      theme: ThemeData(
        useMaterial3: true, //This line might be unecessary
        colorScheme: ColorScheme.fromSeed(
          seedColor: absentRed,
        ),
      ),
    );
  }
}
