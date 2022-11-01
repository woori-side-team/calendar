import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/layout/widgets/custom_app_bar.dart';
import 'package:calendar/layout/widgets/custom_navigation_bar.dart';
import 'package:calendar/schedule/widgets/month_selector.dart';
import 'package:calendar/schedule/widgets/month_view.dart';
import 'package:calendar/schedule/widgets/schedule_sheet.dart';
import 'package:calendar/schedule/widgets/week_page.dart';
import 'package:flutter/material.dart';

class MonthPage extends StatelessWidget {
  static const routeName = 'month';

  const MonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
          Column(children: const [
            CustomAppBar(modeType: CustomAppBarModeType.month),
            MonthSelector(),
            MonthView()
          ]),
          const ScheduleSheet()
        ])),
        bottomNavigationBar: CustomNavigationBar(
          onPressSchedule: () {
            CustomRouteUtils.push(context, WeekPage.routeName);
          },
          onPressChecklist: () {},
          onPressMemo: () {},
          onPressSettings: () {},
        ));
  }
}
