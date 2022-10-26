import 'package:calendar/layout/widgets/custom_app_bar.dart';
import 'package:calendar/layout/widgets/custom_navigation_bar.dart';
import 'package:calendar/schedule/widgets/month_selector.dart';
import 'package:calendar/schedule/widgets/month_view.dart';
import 'package:calendar/schedule/widgets/schedule_sheet.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SchedulePageState();
  }
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime _selectedMonthDate;

  @override
  void initState() {
    super.initState();
    _selectedMonthDate = DateTime(2022, 10);
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
          const ScheduleSheet()
        ])),
        bottomNavigationBar: CustomNavigationBar(
          onPressSchedule: () {},
          onPressChecklist: () {},
          onPressMemo: () {},
          onPressSettings: () {},
        ));
  }
}
