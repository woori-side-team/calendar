import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_bottom_sheet.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/schedule/day_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum _Mode { edit, view }

class ScheduleSheet extends StatefulWidget {
  const ScheduleSheet({super.key, this.minSizeRatio});

  final double? minSizeRatio;

  @override
  State<StatefulWidget> createState() {
    return _ScheduleSheet();
  }
}

class _ScheduleSheet extends State<ScheduleSheet> {
  static final _markerColors = [
    CustomTheme.tint.indigo,
    CustomTheme.tint.orange,
    CustomTheme.tint.pink,
    CustomTheme.tint.teal
  ];

  late _Mode _mode;

  void _handlePressEdit() {
    setState(() {
      _mode = _Mode.edit;
    });
  }

  void _handlePressView() {
    setState(() {
      _mode = _Mode.view;
    });
  }

  @override
  void initState() {
    super.initState();
    _mode = _Mode.view;
  }

  Widget _createHeader() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 14, left: 20, right: 18),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('다가오는 일정',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CustomTheme.scale.scale10)),
          _mode == _Mode.view
              ? TextButton(
                  onPressed: _handlePressEdit,
                  child: Text('편집',
                      style: TextStyle(
                          fontSize: 17, color: CustomTheme.tint.blue)))
              : IconButton(
                  onPressed: _handlePressView,
                  icon:
                      SvgPicture.asset('assets/icons/schedule_sheet_close.svg'))
        ]));
  }

  Widget _createScheduleView(BuildContext context, ScheduleModel schedule) {
    const controlWidth = 24.0;
    const controlHeight = 24.0;

    return Container(
        height: 24,
        margin: const EdgeInsets.only(bottom: 24, right: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(left: 40, right: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _markerColors[
                      schedule.colorIndex % _markerColors.length]),
              child: Text('${schedule.start.day}',
                  style: TextStyle(
                      color: CustomTheme.background.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400))),
          Expanded(
              child: TextButton(
                  onPressed: () {
                    // TODO 여러 날 스케줄은 어떻게?
                    final schedulesProvider = context.read<SchedulesProvider>();
                    schedulesProvider.loadOneDaySchedules(schedule.start);
                    CustomRouteUtils.push(context, DayPage.routeName,
                        arguments: schedule.start);
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.centerLeft),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text('${schedule.title}: ${schedule.content}',
                          style: TextStyle(
                              color: CustomTheme.scale.max,
                              fontSize: 14,
                              fontWeight: FontWeight.w400))))),
          _mode == _Mode.view
              ? Container()
              : Row(children: [
                  SizedBox(
                      width: controlWidth,
                      height: controlHeight,
                      child: IconButton(
                          onPressed: () {
                            // TODO.
                          },
                          padding: const EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                              'assets/icons/schedule_sheet_schedule_edit.svg'))),
                  SizedBox(
                      width: controlWidth,
                      height: controlHeight,
                      child: IconButton(
                          onPressed: () {
                            // TODO.
                          },
                          padding: const EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                              'assets/icons/schedule_sheet_schedule_close.svg')))
                ])
        ]));
  }

  Widget _createDot() {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: CustomTheme.background.tertiary),
        width: 4,
        height: 4,
        margin: const EdgeInsets.only(top: 4));
  }

  Widget _createContent(BuildContext context) {
    final now = CustomDateUtils.getNow();
    final schedules = context.watch<SchedulesProvider>().schedules;
    final schedulesToShow =
        schedules.where((schedule) => schedule.start.month == now.month);

    // 최대 몇개까지만 보여줄지.
    const maxShowCount = 7;

    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Column(children: [
          ...schedulesToShow
              .take(maxShowCount)
              .map((schedule) => _createScheduleView(context, schedule))
              .toList(),
          Container(
              margin: const EdgeInsets.only(top: 4),
              child: Column(
                  children: schedulesToShow.length < maxShowCount
                      ? []
                      : [_createDot(), _createDot(), _createDot()]))
        ]));
  }

  Widget _createCommandTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: TextField(
        style: const TextStyle(fontSize: 15, height: 0.8),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: '일정을 입력하세요.',
          hintStyle: TextStyle(color: CustomTheme.gray.gray2, fontSize: 15),
          fillColor: CustomTheme.background.secondary,
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double minSize = widget.minSizeRatio ?? 0.3;
    double safePadding = MediaQuery.of(context).padding.top;
    double totalHeight = MediaQuery.of(context).size.height;
    double safeTotalRatio = safePadding/totalHeight;
    final double maxSize = 1.0 - safeTotalRatio;

    return CustomBottomSheet(
        minSize: minSize,
        maxSize: maxSize,
        snapSizes: [minSize, 0.5, maxSize],
        child: Column(children: [
          _createCommandTextField(),
          Container(
            color: CustomTheme.gray.gray4,
            height: 1,
          ),
          _createHeader(),
          _createContent(context)
        ]));
  }
}
