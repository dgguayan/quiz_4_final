import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_4_final/firebase_options.dart';
import 'package:quiz_4_final/view/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: "https://isdokcvglocadrraktfe.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzZG9rY3ZnbG9jYWRycmFrdGZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4NjkxOTEsImV4cCI6MjAzMTQ0NTE5MX0.VfTbcxvvZtj8EZyF2Bdv5egJ_if2d495V-riwrFB2SI",
  );

 
  String platform;
  if (kIsWeb) {
    platform = 'Web';
  } else if (Platform.isAndroid) {
    platform = 'Android';
  } else if (Platform.isIOS) {
    platform = 'iOS';
  } else if (Platform.isWindows) {
    platform = 'Windows';
  } else if (Platform.isMacOS) {
    platform = 'macOS';
  } else if (Platform.isLinux) {
    platform = 'Linux';
  } else {
    platform = 'Unknown platform';
  }

  print('Running on $platform');
  await logPlatformUsage(platform);

  runApp(MyApp());
}

Future<void> logPlatformUsage(String platform) async {
  final prefs = await SharedPreferences.getInstance();
  final logList = prefs.getStringList('platform_logs') ?? [];
  logList.add('$platform: ${DateTime.now().toIso8601String()}');
  await prefs.setStringList('platform_logs', logList);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      home: HomePage(), 
    );
  }
}
