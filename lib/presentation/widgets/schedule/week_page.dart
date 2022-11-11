import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_page.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_sheet.dart';
import 'package:calendar/presentation/widgets/schedule/week_view.dart';
import 'package:flutter/material.dart';

class WeekPage extends StatelessWidget {
  static const routeName = 'week';

  const WeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          Column(children: const [
            CustomAppBar(modeType: CustomAppBarModeType.week),
            MonthSelector(),
            WeekView()
          ]),
          const ScheduleSheet()
        ]),
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
