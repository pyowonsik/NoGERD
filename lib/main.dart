import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:no_gerd/apps/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '역류성 식도염 해방일지',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7BB4E3),
          secondary: const Color(0xFFA5D6A7),
        ),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}
