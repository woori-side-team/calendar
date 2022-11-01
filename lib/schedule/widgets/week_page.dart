import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/layout/widgets/custom_app_bar.dart';
import 'package:calendar/layout/widgets/custom_navigation_bar.dart';
import 'package:calendar/schedule/widgets/month_page.dart';
import 'package:calendar/schedule/widgets/month_selector.dart';
import 'package:calendar/schedule/widgets/schedule_sheet.dart';
import 'package:calendar/schedule/widgets/week_view.dart';
import 'package:flutter/material.dart';

class WeekPage extends StatelessWidget {
  static const routeName = 'week';

  const WeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
          Column(children: const [
            CustomAppBar(modeType: CustomAppBarModeType.week),
            MonthSelector(), WeekView()]),
          const ScheduleSheet()
        ])),
        bottomNavigationBar: CustomNavigationBar(
          onPressSchedule: () {
            CustomRouteUtils.push(context, MonthPage.routeName);
          },
          onPressChecklist: () {},
          onPressMemo: () {},
          onPressSettings: () {},
        ));
  }
}
