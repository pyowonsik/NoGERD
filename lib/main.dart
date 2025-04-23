import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:no_gerd/apps/app.dart';
import 'package:no_gerd/features/record/data/models/gerd_record.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(GerdRecordModelAdapter());
  var box = await Hive.openBox<GerdRecordModel>('gerdRecords');

  // Add a record
  box.add(GerdRecordModel(
    date: '2023년 04월 15일',
    symptoms: ['가슴 쓰림', '목 아픔'],
    status: '좋음',
    notes: '오늘은 증상이 경미했습니다. 저녁에 매운 음식을 피했더니 효과가 있었습니다.',
  ));

  // Retrieve records
  List<GerdRecordModel> records = box.values.toList();

  print(box.values.first.toEntity());
  print(box.values.last.toEntity());

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
