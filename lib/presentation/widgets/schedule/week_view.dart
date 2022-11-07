import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WeekViewState();
  }
}

class _WeekViewState extends State<WeekView> {
  static const _dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  late ScrollController _scrollController;
  late DateTime _startDayDate;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _startDayDate = CustomDateUtils.getNow();
  }

  Widget _createDayCard(DateTime dayDate) {
    final textColor = dayDate.weekday == DateTime.sunday
        ? CustomTheme.tint.red
        : dayDate.weekday == DateTime.saturday
            ? CustomTheme.tint.blue
            : CustomTheme.scale.scale8;

    return Container(
        width: 124,
        height: 160,
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 6, right: 6),
        decoration: BoxDecoration(
            border: Border.all(color: CustomTheme.gray.gray5, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${dayDate.day}',
                    style: TextStyle(fontSize: 24, color: textColor)),
                const SizedBox(width: 2),
                Text(_dayNames[dayDate.weekday % 7],
                    style: TextStyle(fontSize: 16, color: textColor))
              ])
        ]));
  }

  Widget _createNextWeekMarker() {
    return VisibilityDetector(
        key: const Key("NextWeekMarker"),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1.0) {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);

            setState(() {
              _startDayDate = DateTime(_startDayDate.year, _startDayDate.month,
                  _startDayDate.day + 7);
            });
          }
        },
        child: Container(
            width: 46,
            height: 160,
            decoration: BoxDecoration(
                border: Border.all(color: CustomTheme.gray.gray5, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: SvgPicture.asset('assets/icons/week_view_next_week.svg')));
  }

  Widget _createDayRow() {
    final List<DateTime> dayDates = [_startDayDate];

    for (var i = 1; i <= 6; i++) {
      dayDates.add(DateTime(
          _startDayDate.year, _startDayDate.month, _startDayDate.day + i));
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Wrap(spacing: 4, children: [
              ...dayDates.map((dayDate) => _createDayCard(dayDate)),
              _createNextWeekMarker()
            ])));
  }

  Widget _createSectionTitle(Widget icon, String title) {
    return Container(
        margin: const EdgeInsets.only(right: 32),
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: CustomTheme.gray.gray3))),
        child: Row(children: [
          icon,
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 18))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 37),
        child: Column(children: [
          _createDayRow(),
          _createSectionTitle(
              Image.asset('assets/icons/week_view_checklist.png'), '금주의 체크리스트'),
          _createSectionTitle(
              Image.asset('assets/icons/week_view_memo.png'), '꼭 잊지 말아야 할 메모')
        ]));
  }
}
