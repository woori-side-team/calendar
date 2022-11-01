import 'package:calendar/common/models/schedule.dart';
import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/layout/widgets/custom_app_bar.dart';
import 'package:calendar/layout/widgets/custom_navigation_bar.dart';
import 'package:calendar/schedule/widgets/month_page.dart';
import 'package:calendar/schedule/widgets/schedule_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayPage extends StatelessWidget {
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

  Widget _createEventRow(Schedule schedule) {
    int time = schedule.start.hour;
    String amPm = time <= 12 ? 'AM' : 'PM';
    String title = '일이삼사오육칠팔구십일이삼';
    String content = schedule.content;
    Color color = _markerColors[schedule.colorIndex];
    double contentBoxHeight = 100;

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
                    '${time % 12}',
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
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            width: 14,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: contentBoxHeight,
                  child: VerticalDivider(
                    color: CustomTheme.scale.scale7,
                    indent: 0,
                    endIndent: 0,
                    width: 0,
                    thickness: 1,
                  ),
                ),
                Positioned(
                  top: 24,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 28, top: 24),
            child: Container(
              height: contentBoxHeight - 24,
              padding: const EdgeInsets.only(left: 13),
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
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomTheme.background.primary,
        body: SafeArea(
            child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(modeType: CustomAppBarModeType.hidden),
                Card(
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
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                  ),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      width: 5,
                      color: Colors.red,
                    ),
                    ListView(
                      children: [
                        _createEventRow(Schedule(
                            tag: '개인',
                            content: '공부하기',
                            type: ScheduleType.allDay,
                            start: DateTime(2022, 9, 28, 13),
                            end: DateTime(2022, 10, 2, 10),
                            colorIndex: 0),),
                        _createEventRow(Schedule(
                            tag: '개인',
                            content: '공부하기',
                            type: ScheduleType.allDay,
                            start: DateTime(2022, 9, 28, 10),
                            end: DateTime(2022, 10, 2),
                            colorIndex: 0),),
                      ],
                    ),
                  ],
                )),
              ],
            ),
            const ScheduleSheet(),
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
