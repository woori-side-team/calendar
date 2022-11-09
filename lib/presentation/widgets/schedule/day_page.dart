import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_page.dart';
import 'package:calendar/presentation/widgets/schedule/schedule_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/marker_colors.dart';

class DayPage extends StatelessWidget {
  static const routeName = 'day';
  final DateTime selectedDate;

  DayPage({super.key, required this.selectedDate});

  Widget _createLimitedScheduleTextContainer({
    required String title,
    required String content,
    required Color color,
    required double contentBoxHeight,
  }) {
    return Container(
      height: contentBoxHeight - 24,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: CustomTheme.groupedBackground.primary,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            content,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: CustomTheme.groupedBackground.primary.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _createAllDayScheduleTextContainer({
    required String title,
    required String content,
    required Color color,
    required double contentBoxHeight,
  }) {
    return SizedBox(
      height: contentBoxHeight - 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: CustomTheme.scale.scale8,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            content,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: CustomTheme.scale.scale8.withOpacity(0.5),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _createScheduleRow(ScheduleModel schedule) {
    final int time = schedule.start.hour;
    final String amPm = time < 12 ? 'AM' : 'PM';
    final String title = schedule.title;
    final String content = schedule.content;
    final Color color = markerColors[schedule.colorIndex];
    int progressTime = schedule.end.hour - schedule.start.hour;
    if (progressTime < 0) progressTime = 1;
    final double contentBoxHeight = 100 + progressTime.toDouble() * 25;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 37, top: 24),
              child: Container(
                width: 21,
                height: 22,
                alignment: AlignmentDirectional.centerEnd,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Text(
                    '${time % 12 == 0 ? 12 : time % 12}',
                    style: TextStyle(
                        height: 11 / 12,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: markerColors[schedule.colorIndex]),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 36, right: 1),
              width: 21,
              height: 12,
              alignment: AlignmentDirectional.centerEnd,
              child: FittedBox(
                fit: BoxFit.none,
                child: Text(
                  amPm,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: CustomTheme.gray.gray1),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 24),
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                left: schedule.type == ScheduleType.hours ? 14 : 28,
                top: 24,
                right: 12),
            child: schedule.type == ScheduleType.hours
                ? _createLimitedScheduleTextContainer(
                    title: title,
                    content: content,
                    color: color,
                    contentBoxHeight: contentBoxHeight,
                  )
                : _createAllDayScheduleTextContainer(
                    title: title,
                    content: content,
                    color: color,
                    contentBoxHeight: contentBoxHeight,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _createDateCard({required DateTime date}) {
    return Card(
      color: CustomTheme.background.primary,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.16),
      elevation: 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomTheme.background.primary,
        ),
        padding: const EdgeInsets.only(left: 20, bottom: 40),
        child: Text(
          DateFormat('yyyy-MM-dd').format(date),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedulesProvider = context.watch<SchedulesProvider>();
    return Scaffold(
        backgroundColor: CustomTheme.background.primary,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                schedulesProvider.addSchedule(2, selectedDate);
              },
              child: const Text('2'),
            ),
            FloatingActionButton(
              onPressed: () {
                schedulesProvider.addSchedule(3, selectedDate);
              },
              child: const Text('3'),
            ),
            FloatingActionButton(
              onPressed: () {
                schedulesProvider.addAllDaySchedule(selectedDate);
              },
              child: const Text('All'),
            ),
          ],
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomAppBar(modeType: CustomAppBarModeType.hidden),
                _createDateCard(date: selectedDate),
                Flexible(
                    child: Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 5,
                                  color: markerColors[schedulesProvider
                                          .allDaySchedulesColorIndexes[
                                      index % markerColors.length]],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 0.1,
                                );
                              },
                              itemCount: schedulesProvider
                                  .allDaySchedulesColorIndexes.length),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 77.0),
                      child: VerticalDivider(
                        color: CustomTheme.scale.scale7,
                        indent: 0,
                        endIndent: 0,
                        width: 0,
                        thickness: 1,
                      ),
                    ),
                    ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: schedulesProvider.oneDaySchedules.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _createScheduleRow(
                            schedulesProvider.oneDaySchedules[index]);
                      },
                    ),
                  ],
                )),
              ],
            ),
            const ScheduleSheet(
              minSizeRatio: 0.03,
            ),
          ],
        )),
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
