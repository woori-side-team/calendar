import 'package:calendar/common/custom_theme.dart';
import 'package:calendar/layout/custom_navigation_bar.dart';
import 'package:calendar/schedule/schedule_sheet.dart';
import 'package:flutter/material.dart';

import 'layout/custom_app_bar.dart';

class App extends StatelessWidget {
  final _sheetController = DraggableScrollableController();

  App({super.key});

  void _handlePressSchedule() {
    const duration = Duration(milliseconds: 500);
    const curve = Curves.ease;

    if (_sheetController.size >= ScheduleSheet.maxSize) {
      _sheetController.animateTo(ScheduleSheet.minSize,
          duration: duration, curve: curve);
    } else {
      _sheetController.animateTo(ScheduleSheet.maxSize,
          duration: duration, curve: curve);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultNavigationBarTheme = NavigationBarTheme.of(context);

    final customNavigationBarTheme = defaultNavigationBarTheme.copyWith(
        indicatorColor: CustomTheme.background.primary,
        labelTextStyle: MaterialStatePropertyAll(
            TextStyle(color: CustomTheme.scale.scale9)));

    final customThemeData = ThemeData(
        fontFamily: 'Pretendard', navigationBarTheme: customNavigationBarTheme);

    return MaterialApp(
        title: 'Calendar',
        theme: customThemeData,
        home: Scaffold(
            appBar: const CustomAppBar(),
            body: SafeArea(
                child: Stack(
                    children: [ScheduleSheet(controller: _sheetController)])),
            bottomNavigationBar: CustomNavigationBar(
              onPressSchedule: _handlePressSchedule,
              onPressChecklist: () {},
              onPressMemo: () {},
              onPressSettings: () {},
            )));
  }
}
