import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:no_gerd/apps/app.dart';
import 'package:no_gerd/features/gerd_record/data/models/gerd_record_model.dart';
import 'package:no_gerd/injection.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(GerdRecordModelAdapter());

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '꾸르꾸웍',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7BB4E3),
          secondary: const Color(0xFFA5D6A7),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
