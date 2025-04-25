import 'package:flutter/material.dart';

import 'package:no_gerd/features/gerd_record/presentation/pages/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomeScreen());
  }
}
