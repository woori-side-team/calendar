import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/memo/memo_edit_page.dart';
import 'package:calendar/presentation/widgets/memo/memo_view_pages.dart';
import 'package:calendar/presentation/widgets/schedule/day_page.dart';
import 'package:calendar/presentation/widgets/schedule/month_page.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_search_page.dart';
import 'package:calendar/presentation/widgets/schedule/week_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp.router(
        title: 'Calendar', theme: customThemeData, routerConfig: _router);
  }
}

final _router = GoRouter(initialLocation: '/schedule/month', routes: [
  GoRoute(
      name: 'monthPage',
      path: '/schedule/month',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MonthPage())),
  GoRoute(
      name: 'weekPage',
      path: '/schedule/week',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: WeekPage())),
  GoRoute(
      name: 'dayPage',
      path: '/schedule/day/:selectedDate',
      builder: (context, state) => DayPage(
          selectedDate: DateTime.fromMillisecondsSinceEpoch(
              int.parse(state.params['selectedDate']!)))),
  // 검색 창은 뒤로가기가 되게끔
  GoRoute(
      name: 'scheduleSearchPage',
      path: '/schedule/search',
      builder: (context, state) => const ScheduleSearchPage()),
  GoRoute(
      name: 'memoGridViewPage',
      path: '/memo/grid',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MemoGridViewPage())),
  GoRoute(
      name: 'memoListViewPage',
      path: '/memo/list',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MemoListViewPage())),
  GoRoute(
      name: 'memoEditPage',
      path: '/memo/edit',
      pageBuilder: (context, state) => NoTransitionPage(
          child: MemoEditPage(memoModel: state.extra as MemoModel))),
]);
