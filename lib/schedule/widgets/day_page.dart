import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/layout/widgets/custom_app_bar.dart';
import 'package:calendar/layout/widgets/custom_navigation_bar.dart';
import 'package:calendar/schedule/widgets/month_page.dart';
import 'package:flutter/material.dart';

class DayPage extends StatelessWidget {
  static const routeName = 'day';

  const DayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(modeType: CustomAppBarModeType.hidden),
        body: const SafeArea(child: Text('Day view')),
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
