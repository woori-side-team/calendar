import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                margin: const EdgeInsets.only(top: 37, bottom: 72),
                child: Column(children: [
                  const _DayRow(),
                  _SectionTitle(
                      icon: Image.asset('assets/icons/week_view_checklist.png'),
                      title: '금주의 체크리스트'),
                  const _ChecklistColumn(),
                  _SectionTitle(
                      icon: Image.asset('assets/icons/week_view_memo.png'),
                      title: '꼭 잊지 말아야 할 메모'),
                  const _MemoRow()
                ]))));
  }
}

class _SectionTitle extends StatelessWidget {
  final Widget icon;
  final String title;

  const _SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 32, bottom: 10),
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: CustomTheme.gray.gray3))),
        child: Row(children: [
          icon,
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 18))
        ]));
  }
}

class _DayRow extends StatefulWidget {
  const _DayRow({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DayRowState();
  }
}

class _DayRowState extends State<_DayRow> {
  late ScrollController _scrollController;
  late DateTime _startDayDate;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _startDayDate = CustomDateUtils.getNow();
  }

  @override
  Widget build(BuildContext context) {
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
              ...dayDates.map((dayDate) => _DayCard(dayDate: dayDate)),
              VisibilityDetector(
                  key: const Key("NextWeekMarker"),
                  onVisibilityChanged: (visibilityInfo) {
                    if (visibilityInfo.visibleFraction == 1.0) {
                      _scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);

                      setState(() {
                        _startDayDate = DateTime(_startDayDate.year,
                            _startDayDate.month, _startDayDate.day + 7);
                      });
                    }
                  },
                  child: Container(
                      width: 46,
                      height: 160,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.gray.gray5, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: SvgPicture.asset(
                          'assets/icons/week_view_next_week.svg')))
            ])));
  }
}

class _DayCard extends StatelessWidget {
  static const _dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  final DateTime dayDate;

  const _DayCard({super.key, required this.dayDate});

  @override
  Widget build(BuildContext context) {
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
}

class _ChecklistColumn extends StatelessWidget {
  const _ChecklistColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      _ChecklistItem(content: '일이삼사오육칠팔구십일이삼사오육칠팔구', dDay: 1),
      _ChecklistItem(content: '일이삼사오육칠팔구십일이삼사오육칠팔구', dDay: 11),
      _ChecklistItem(content: '일이삼사오육칠팔구십일이삼사오육칠팔구', dDay: 31),
      _ChecklistItem(content: '일이삼사오육칠팔구십일이삼사오육칠팔구', dDay: 1010)
    ]);
  }
}

class _ChecklistItem extends StatelessWidget {
  final String content;
  final int dDay;

  const _ChecklistItem({super.key, required this.content, required this.dDay});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(left: 28, right: 24, top: 10, bottom: 10),
        child: Row(children: [
          Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: CustomTheme.gray.gray3, width: 1))),
          Text(content,
              style: TextStyle(
                  color: CustomTheme.label.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          Expanded(
              child: Text('D-$dDay',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: CustomTheme.gray.gray1,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)))
        ]));
  }
}

class _MemoRow extends StatelessWidget {
  const _MemoRow({super.key});

  @override
  Widget build(BuildContext context) {
    const content = '일이삼사오육칠\n일이삼사오육칠\n일이삼사오육칠\n일이삼사오육칠';

    return Container(
        padding: const EdgeInsets.only(left: 16, right: 6),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: const [
              _MemoItem(content: content),
              _MemoItem(content: content),
              _MemoItem(content: content),
              _MemoItem(content: content)
            ])));
  }
}

class _MemoItem extends StatelessWidget {
  final String content;

  const _MemoItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 120,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.only(top: 11, bottom: 11, left: 8, right: 8),
        decoration: BoxDecoration(
            border: Border.all(color: CustomTheme.gray.gray5, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Text(content,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: CustomTheme.scale.scale8)));
  }
}
