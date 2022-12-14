import 'dart:io' show Platform;

import 'package:calendar/app.dart';
import 'package:calendar/common/di/di.dart';
import 'package:calendar/data/data_sources/local/memo_entity.dart';
import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/presentation/providers/memos_provider.dart';
import 'package:calendar/presentation/providers/schedule_search_provider.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  // 필수 작업.
  WidgetsFlutterBinding.ensureInitialized();

  // DI 세팅.
  configureDependencies();

  // DB 세팅.
  await Hive.initFlutter();
  Hive.registerAdapter(ScheduleEntityAdapter());
  Hive.registerAdapter(MemoEntityAdapter());

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
  }

  // 앱 세팅 및 시작.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SheetProvider()),
    ChangeNotifierProvider(create: (context) => getIt<SchedulesProvider>()),
    ChangeNotifierProvider(
        create: (context) => getIt<ScheduleSearchProvider>()),
    ChangeNotifierProvider(create: (context) => getIt<MemosProvider>())
  ], child: const App()));
}
