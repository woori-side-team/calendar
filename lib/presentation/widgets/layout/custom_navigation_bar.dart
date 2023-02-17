import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum CustomNavigationType { schedule, checklist, memo, settings }

class CustomNavigationBar extends StatelessWidget {
  final CustomNavigationType selectedType;
  final void Function()? onPressSchedule;
  final void Function()? onPressChecklist;
  final void Function()? onPressMemo;
  final void Function()? onPressSettings;
  final int? sheetIndex;

  const CustomNavigationBar(
      {super.key,
      required this.selectedType,
      this.onPressSchedule,
      this.onPressChecklist,
      this.onPressMemo,
      this.onPressSettings,
      this.sheetIndex});

  @override
  Widget build(BuildContext context) {
    // 참고: 모든 스타일이 인수로 뚫려있진 않아서, 일부 스타일은 app.dart의 ThemeData에서 설정해야 함.
    return NavigationBar(
        selectedIndex: selectedType.index,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              // TODO: weekView 완성되면 주석 해제
              if (onPressSchedule != null) {
                //onPressSchedule!();
              } else {
                //context.pushNamed('monthPage');
              }

              break;
            case 1:
              if (onPressChecklist != null) {
                onPressChecklist!();
              } else {
                // TODO.
                context.read<SheetProvider>().moveSheetWithButton(sheetIndex!);
              }

              break;
            case 2:
              if (onPressMemo != null) {
                onPressMemo!();
              } else {
                context.pushNamed('memoGridViewPage');
              }

              break;
            case 3:
              if (onPressSettings != null) {
                onPressSettings!();
              } else {
                // TODO.
              }

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
              label: '다가올 일정',
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

  CustomNavigationBar copyWith({
    CustomNavigationType? selectedType,
    Function()? onPressSchedule,
    Function()? onPressChecklist,
    Function()? onPressMemo,
    Function()? onPressSettings,
    int? sheetIndex,
  }) {
    return CustomNavigationBar(
      selectedType: selectedType ?? this.selectedType,
      onPressSchedule: onPressSchedule ?? this.onPressSchedule,
      onPressChecklist: onPressChecklist ?? this.onPressChecklist,
      onPressMemo: onPressMemo ?? this.onPressMemo,
      onPressSettings: onPressSettings ?? this.onPressSettings,
      sheetIndex: sheetIndex ?? this.sheetIndex,
    );
  }
}
