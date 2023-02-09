import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_carousel.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/layout/scaffold_overlay_bottom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/month_view.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_sheet.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
              const _MonthViewCarousel()
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

class _MonthViewCarousel extends StatelessWidget {
  const _MonthViewCarousel();

  @override
  Widget build(BuildContext context) {
    final schedulesProvider = context.watch<SchedulesProvider>();

    return Expanded(
        child: CustomCarousel<DateTime>(
            options: CarouselOptions(
                height: double.infinity,
                enableInfiniteScroll: false,
                autoPlay: false,
                viewportFraction: 1),
            items: schedulesProvider.neighborMonthDates,
            selectedIndex: schedulesProvider.selectedNeighborMonthDateIndex,
            onPageChanged: (index) {
              schedulesProvider.selectNeighborMonthDate(index);
            },
            renderItem: (item, isActive, index, controller) {
              return MonthView(monthDate: item);
            }));
  }
}
