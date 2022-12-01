import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  const CustomAppBar({super.key, required this.actions});

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: actions);
  }
}

/// 검색 버튼.
class CustomAppBarSearchButton extends StatelessWidget {
  const CustomAppBarSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/icons/app_bar_search.svg'));
  }
}

enum CustomAppBarModeType { vertical, horizontal }

/// 모드 버튼. (세로 / 가로 지원)
class CustomAppBarModeButton extends StatelessWidget {
  final CustomAppBarModeType type;
  final void Function() onPressed;

  const CustomAppBarModeButton(
      {super.key, required this.type, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: type == CustomAppBarModeType.vertical ? 1 : 0,
        child: IconButton(
            icon: SvgPicture.asset('assets/icons/app_bar_mode.svg'),
            onPressed: onPressed));
  }
}

/// 프로필 버튼.
class CustomAppBarProfileButton extends StatelessWidget {
  const CustomAppBarProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/icons/app_bar_profile.svg'));
  }
}