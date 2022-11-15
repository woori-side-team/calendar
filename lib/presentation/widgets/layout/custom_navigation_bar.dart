import 'package:calendar/presentation/widgets/common/custom_theme.dart';
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
    // 참고: 모든 스타일이 인수로 뚫려있진 않아서, 일부 스타일은 app.dart의 ThemeData에서 설정해야 함.
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