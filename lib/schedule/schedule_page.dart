import 'package:calendar/layout/custom_app_bar.dart';
import 'package:calendar/layout/custom_navigation_bar.dart';
import 'package:calendar/schedule/month_selector.dart';
import 'package:calendar/schedule/month_view.dart';
import 'package:calendar/schedule/schedule_sheet.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SchedulePageState();
  }
}

class _SchedulePageState extends State<SchedulePage> {
  late final DraggableScrollableController _sheetController;
  late DateTime _selectedMonthDate;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _selectedMonthDate = DateTime(2022, 10);
  }

  void _handlePressSchedule() {
    const duration = Duration(milliseconds: 500);
    const curve = Curves.ease;

    if (_sheetController.size >= ScheduleSheet.maxSize) {
      _sheetController.animateTo(ScheduleSheet.minSize,
          duration: duration, curve: curve);
    } else {
      _sheetController.animateTo(ScheduleSheet.maxSize,
          duration: duration, curve: curve);
    }
  }

  void _handleSelectMonth(DateTime newMonthDate) {
    setState(() {
      _selectedMonthDate = newMonthDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
            child: Stack(children: [
          Column(children: [
            MonthSelector(
                selectedMonthDate: _selectedMonthDate,
                onSelectMonthDate: _handleSelectMonth),
            MonthView(selectedMonthDate: _selectedMonthDate)
          ]),
          ScheduleSheet(controller: _sheetController)
        ])),
        bottomNavigationBar: CustomNavigationBar(
          onPressSchedule: _handlePressSchedule,
          onPressChecklist: () {},
          onPressMemo: () {},
          onPressSettings: () {},
        ));
  }
}
