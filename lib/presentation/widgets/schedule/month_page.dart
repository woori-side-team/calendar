import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/month_view.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonthPage extends StatelessWidget {
  static const routeName = 'schedule/month';

  const MonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          Column(children: [
            CustomAppBar(actions: [
              const CustomAppBarSearchButton(type: PageType.schedule),
              CustomAppBarModeButton(
                  type: CustomAppBarModeType.vertical,
                  onPressed: () {
                    context.pushNamed('weekPage');
                  }),
              const CustomAppBarProfileButton()
            ]),
            const MonthSelector(),
            const MonthView()
          ]),
          const ScheduleSheet(minSizeRatio: 0.275)
        ]),
        bottomNavigationBar: CustomNavigationBar(
            selectedType: CustomNavigationType.schedule,
            onPressSchedule: () {
              context.pushNamed('weekPage');
            }));
  }
}
