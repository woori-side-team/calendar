import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  Widget _createAction(
      {required Widget icon, required void Function() onPressed}) {
    return IconButton(onPressed: onPressed, icon: icon);
  }

  void _handlePressSearch() {}

  void _handlePressMode() {}

  void _handlePressProfile() {}

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
      _createAction(
          icon: SvgPicture.asset('assets/icons/app_bar_search.svg'),
          onPressed: _handlePressSearch),
      _createAction(
          icon: SvgPicture.asset('assets/icons/app_bar_mode.svg'),
          onPressed: _handlePressMode),
      _createAction(
          icon: SvgPicture.asset('assets/icons/app_bar_profile.svg'),
          onPressed: _handlePressProfile)
    ]);
  }
}
