import 'package:calendar/common/providers/schedules_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (providerContext) => SchedulesProvider())
  ], child: const App()));
}
