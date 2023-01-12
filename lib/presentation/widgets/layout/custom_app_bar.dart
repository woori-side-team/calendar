import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

const double _buttonSize = 26;

class CustomAppBar extends StatelessWidget {
  final List<Widget> leftActions;
  final List<Widget> rightActions;
  final bool? isScheduleAppBar;

  const CustomAppBar(
      {super.key,
      this.leftActions = const [],
      this.rightActions = const [],
      this.isScheduleAppBar});

  Widget _createLeftAction() {
    if (isScheduleAppBar == true) {
      return AddScheduleButton();
    }
    return Row(children: [...leftActions]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Container(
          padding: const EdgeInsets.only(right: 12),
          height: 56,
          child: Row(children: [
            _createLeftAction(),
            Expanded(child: Container()),
            ...rightActions
          ]),
        ),
      ],
    );
  }
}

class AddScheduleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(
        width: 19,
      ),
      SizedBox(
        height: 32,
        width: 83,
        child: ElevatedButton(
          onPressed: () {
            context.pushNamed('addSchedulePage');
          },
          style: ElevatedButton.styleFrom(
            elevation: 1.5,
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            backgroundColor: CustomTheme.background.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                color: CustomTheme.scale.scale7,
              ),
              Text(
                '일정 추가',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: CustomTheme.scale.scale7,
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

enum PageType { schedule, memo }

/// 검색 버튼.
class CustomAppBarSearchButton extends StatelessWidget {
  final String _scheduleSearchPageName = 'scheduleSearchPage';
  final PageType type;

  const CustomAppBarSearchButton({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          switch (type) {
            case PageType.schedule:
              context.pushNamed(_scheduleSearchPageName);
              break;
            case PageType.memo:
              // TODO: Handle this case.
              break;
          }
        },
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: _buttonSize,
              width: _buttonSize,
              child: SvgPicture.asset('assets/icons/app_bar_search.svg')),
        ));
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
        child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: _buttonSize,
                  width: _buttonSize,
                  child: SvgPicture.asset('assets/icons/app_bar_mode.svg')),
            )));
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

/// 뒤로 가기 버튼.
class CustomAppBarBackButton extends StatelessWidget {
  const CustomAppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.pop();
        },
        icon: SvgPicture.asset('assets/icons/app_bar_back.svg'));
  }
}

/// 메뉴 버튼.
class CustomAppBarMenuButton extends StatelessWidget {
  final void Function() onPressed;

  const CustomAppBarMenuButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset('assets/icons/app_bar_menu.svg'));
  }
}

/// 편집 버튼.
class CustomAppBarEditButton extends StatelessWidget {
  final void Function() onPressed;

  const CustomAppBarEditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset('assets/icons/app_bar_edit.svg'));
  }
}
