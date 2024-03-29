import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/layout/scaffold_overlay_bottom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/week_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WeekPage extends StatelessWidget {
  static const routeName = 'schedule/week';

  const WeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldOverlayBottomNavigationBar(
      scaffold: Scaffold(
        body: Stack(children: [
          Column(children: [
            CustomAppBar(rightActions: [
              CustomAppBarModeButton(
                  type: CustomAppBarModeType.horizontal,
                  onPressed: () {
                    context.pushNamed('monthPage');
                  }),
              const CustomAppBarSearchButton(type: PageType.schedule),
            ]),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:
                        Column(children: const [MonthSelector(), WeekView()]))),
          ]),
        ]),
      ),
      bottomNavigationBar: const CustomNavigationBar(
          selectedType: CustomNavigationType.schedule),
    );
  }
}
