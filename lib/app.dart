import 'package:calendar/common/custom_theme.dart';
import 'package:calendar/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'layout/custom_app_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultNavigationBarTheme = NavigationBarTheme.of(context);

    final customNavigationBarTheme = defaultNavigationBarTheme.copyWith(
        indicatorColor: CustomTheme.background.primary,
        labelTextStyle: MaterialStatePropertyAll(
            TextStyle(color: CustomTheme.scale.scale9)));

    return MaterialApp(
        title: 'Calendar',
        theme: ThemeData(navigationBarTheme: customNavigationBarTheme),
        home: const Scaffold(
            appBar: CustomAppBar(),
            bottomNavigationBar: CustomNavigationBar()));
  }
}
