import 'package:calendar/common/utils/custom_route_utils.dart';
import 'package:calendar/presentation/widgets/schedule/month_page.dart';
import 'package:calendar/presentation/widgets/schedule/week_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 모드 버튼을 어떻게 표시할 건지.
enum CustomAppBarModeType { month, week, hidden }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomAppBarModeType modeType;

  const CustomAppBar({super.key, required this.modeType});

  Widget _createAction(
      {required Widget icon, required void Function() onPressed}) {
    return IconButton(onPressed: onPressed, icon: icon);
  }

  void _handlePressSearch() {}

  void _handlePressMode(BuildContext context) {
    if (modeType == CustomAppBarModeType.month) {
      CustomRouteUtils.push(context, WeekPage.routeName);
    } else if (modeType == CustomAppBarModeType.week) {
      CustomRouteUtils.push(context, MonthPage.routeName);
    } else {
      CustomRouteUtils.push(context, MonthPage.routeName);
    }
  }

  void _handlePressProfile() {}

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  Widget _createModeAction(BuildContext context) {
    if (modeType == CustomAppBarModeType.hidden) {
      return Container();
    }

    return RotatedBox(
        quarterTurns: modeType == CustomAppBarModeType.month ? 1 : 0,
        child: _createAction(
            icon: SvgPicture.asset('assets/icons/app_bar_mode.svg'),
            onPressed: () {
              _handlePressMode(context);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _createAction(
              icon: SvgPicture.asset('assets/icons/app_bar_search.svg'),
              onPressed: _handlePressSearch),
          _createModeAction(context),
          _createAction(
              icon: SvgPicture.asset('assets/icons/app_bar_profile.svg'),
              onPressed: _handlePressProfile)
        ]);
  }
}
