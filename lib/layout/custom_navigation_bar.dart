import 'package:calendar/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        height: 80,
        backgroundColor: CustomTheme.background.secondary,
        destinations: [
          NavigationDestination(
              label: '일정',
              icon:
                  SvgPicture.asset('assets/icons/navigation_bar_schedule.svg')),
          NavigationDestination(
              label: '체크리스트',
              icon: SvgPicture.asset('assets/icons/navigation_bar_check.svg')),
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
