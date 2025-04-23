import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:no_gerd/features/record/presentation/pages/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // 그라데이션 배경 적용
        body: HomeScreen());
  }
}
