import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/schedule/day_page.dart';
import 'package:calendar/presentation/widgets/schedule/month_page.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_search_page.dart';
import 'package:calendar/presentation/widgets/schedule/week_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

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
        home: const MonthPage(),
        initialRoute: MonthPage.routeName,
        onGenerateRoute: (routeSettings) {
          if (routeSettings.name == WeekPage.routeName) {
            return CustomRouteUtils.createRoute(() => const WeekPage());
          } else if (routeSettings.name == DayPage.routeName) {
            // 터치한 날짜
            final args = routeSettings.arguments as DateTime;
            return CustomRouteUtils.createRoute(() => DayPage(
                  selectedDate: args,
                ));
          } else if (routeSettings.name == MonthPage.routeName){
            return CustomRouteUtils.createRoute(() => const MonthPage());
          } else {
            return CustomRouteUtils.createRoute(() => const ScheduleSearchPage());
          }
        });
  }
}
