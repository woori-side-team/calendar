import 'package:calendar/common/models/schedule.dart';
import 'package:calendar/common/providers/day_page_schedule_list_provider.dart';
import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/layout/widgets/custom_app_bar.dart';
import 'package:calendar/layout/widgets/custom_navigation_bar.dart';
import 'package:calendar/schedule/widgets/month_page.dart';
import 'package:calendar/schedule/widgets/schedule_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayPage extends StatefulWidget {
  static const routeName = 'day';
  final DateTime selectedDate;

  // 글로벌로 돌리기
  static final _markerColors = [
    CustomTheme.tint.indigo,
    CustomTheme.tint.orange,
    CustomTheme.tint.pink,
    CustomTheme.tint.teal
  ];

  const DayPage({super.key, required this.selectedDate});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  double bottomSheetPosition = 0;

  Widget _createLimitedScheduleTextContainer({
    required String title,
    required String content,
    required Color color,
    required double contentBoxHeight,
  }) {
    return Container(
      height: contentBoxHeight - 24,
      padding: const EdgeInsets.only(left: 13, top: 4),
      decoration: BoxDecoration(
          color: CustomTheme.groupedBackground.primary,
          border: Border(left: BorderSide(color: color, width: 3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.w500),
          ),
          Text(
            content,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: color.withOpacity(0.5),
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
                color: color,
                fontWeight: FontWeight.w500),
          ),
          Text(
            content,
            style: TextStyle(
                height: 1.2,
                fontSize: 18,
                color: color.withOpacity(0.5),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _createScheduleRow(Schedule schedule) {
    final int time = schedule.start.hour;
    final String amPm = time < 12 ? 'AM' : 'PM';
    const String title = '일이삼사오육칠팔구십일이삼사오육칠팔구십';
    final String content = schedule.content;
    final Color color = DayPage._markerColors[schedule.colorIndex];
    int progressTime = schedule.end.hour - schedule.start.hour;
    if (progressTime < 0) progressTime = 1;
    final double contentBoxHeight = 100 + (progressTime.toDouble() - 1) * 25;

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
                        color: CustomTheme.scale.scale10),
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
            padding: const EdgeInsets.only(left: 28, top: 24),
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
    // 페이지 뒤로가기를 하면 provider가 초기화되게 하기 위함.
    return ChangeNotifierProvider<DayPageScheduleListProvider>(
      create: (context) => DayPageScheduleListProvider(),
      builder: (context, _) {
        final scheduleListProvider =
            context.watch<DayPageScheduleListProvider>();
        scheduleListProvider.init();
        return Scaffold(
            backgroundColor: CustomTheme.background.primary,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    scheduleListProvider.addSchedule(2);
                  },
                  child: const Text('2'),
                ),
                FloatingActionButton(
                  onPressed: () {
                    scheduleListProvider.addSchedule(3);
                  },
                  child: const Text('3'),
                ),
                FloatingActionButton(
                  onPressed: () {
                    scheduleListProvider.addAllDaySchedule();
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
                    _createDateCard(date: widget.selectedDate),
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
                                    return Container(width: 5, color: DayPage._markerColors[index%4],);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 0.1,);
                                  },
                                  itemCount: scheduleListProvider.allDaySchedulesColorIndexes.length),
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
                          controller: scheduleListProvider.scrollController,
                          itemCount: scheduleListProvider.schedules.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _createScheduleRow(
                                scheduleListProvider.schedules[index]);
                          },
                        ),
                      ],
                    )),
                  ],
                ),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInSine,
                    padding: EdgeInsets.only(
                        top: scheduleListProvider.bottomSheetPosition),
                    child: const ScheduleSheet()),
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
      },
    );
  }
}