import 'dart:io';

import 'package:colorama/configuration/colors.dart';
import 'package:colorama/firebase_options.dart';
import 'package:colorama/pages/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  if (!Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // colorScheme: const ColorScheme(
        //   brightness: Brightness.light,
        //   primary: surfaceColor,
        //   onPrimary: Colors.white,
        //   secondary: secondaryColor,
        //   onSecondary: Colors.white,
        //   error: Colors.red,
        //   onError: Colors.white,
        //   background: backgroundColor,
        //   onBackground: Colors.white,
        //   surface: primaryColor,
        //   onSurface: Colors.white,
        // ),
      ),
      home: const StartPage(),
    );
  }
}
