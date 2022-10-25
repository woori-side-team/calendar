import 'package:calendar/common/styles/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavigationBar extends StatelessWidget {
  final void Function() onPressSchedule;
  final void Function() onPressChecklist;
  final void Function() onPressMemo;
  final void Function() onPressSettings;

  const CustomNavigationBar(
      {super.key,
      required this.onPressSchedule,
      required this.onPressChecklist,
      required this.onPressMemo,
      required this.onPressSettings});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              onPressSchedule();
              break;
            case 1:
              onPressChecklist();
              break;
            case 2:
              onPressMemo();
              break;
            case 3:
              onPressSettings();
              break;
          }
        },
        height: 80,
        backgroundColor: CustomTheme.background.secondary,
        destinations: [
          NavigationDestination(
              label: '일정',
              icon:
                  SvgPicture.asset('assets/icons/navigation_bar_schedule.svg')),
          NavigationDestination(
              label: '체크리스트',
              icon: SvgPicture.asset(
                  'assets/icons/navigation_bar_checklist.svg')),
          NavigationDestination(
              label: '메모',
              icon: SvgPicture.asset('assets/icons/navigation_bar_memo.svg')),
          NavigationDestination(
              label: '설정',
              icon:
                  SvgPicture.asset('assets/icons/navigation_bar_settings.svg'))
        ]);
  }
}
