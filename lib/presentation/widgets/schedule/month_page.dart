import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/month_view.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_sheet.dart';
import 'package:calendar/presentation/widgets/schedule/week_page.dart';
import 'package:flutter/material.dart';

class MonthPage extends StatelessWidget {
  static const routeName = 'month';

  const MonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          Column(children: const [
            CustomAppBar(modeType: CustomAppBarModeType.month),
            MonthSelector(),
            MonthView()
          ]),
          const ScheduleSheet(minSizeRatio: 0.275)
        ]),
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
