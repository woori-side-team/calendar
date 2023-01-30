import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/layout/scaffold_overlay_bottom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/month_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonthPage extends StatelessWidget {
  static const routeName = 'schedule/month';

  const MonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldOverlayBottomNavigationBar(
        scaffold: Scaffold(
          body: Stack(children: [
            Column(children: [
              CustomAppBar(isScheduleAppBar: true, rightActions: [
                CustomAppBarModeButton(
                    type: CustomAppBarModeType.vertical,
                    onPressed: () {
                      context.pushNamed('weekPage');
                    }),
                const CustomAppBarSearchButton(type: PageType.schedule),
              ]),
              const MonthSelector(),
              const MonthView()
            ]),
          ]),
        ),
        bottomNavigationBar: CustomNavigationBar(
            selectedType: CustomNavigationType.schedule,
            onPressSchedule: () {
              context.pushNamed('weekPage');
            }));
  }
}
