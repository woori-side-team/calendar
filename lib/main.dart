import 'package:calendar/app.dart';
import 'package:calendar/common/di/di.dart';
import 'package:calendar/data/data_sources/local/schedule_entity.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:flutter/material.dart';
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

  // 앱 세팅 및 시작.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SheetProvider()),
    ChangeNotifierProvider(create: (context) => getIt<SchedulesProvider>())
  ], child: const App()));
}
