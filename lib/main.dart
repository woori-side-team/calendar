import 'package:calendar/common/providers/schedules_provider.dart';
import 'package:calendar/common/providers/selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SchedulesProvider()),
    ChangeNotifierProvider(create: (context) => SelectionProvider()),
  ], child: const App()));
}
