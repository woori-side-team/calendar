import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:calendar/presentation/widgets/common/section.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemoGridViewPage extends StatelessWidget {
  static const routeName = 'memo/grid';

  const MemoGridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> dummyMemos = [];

    for (var i = 0; i < 10; i++) {
      dummyMemos.add(const Text(
          '하나에 가득 우는 어머니, 듯합니다. 밤을 나는 별들을 까닭입니다. 나는 노루, 가을로 이름을 패, 내 거외다. 책상을 우는 나의 별 릴케 것은 까닭입니다. 아직 내린 하나에 아침이 나의 이국 그리고 까닭입니다. 시인의 지나가는 부끄러운 슬퍼하는 있습니다. 하나에 하늘에는 않은 내 불러 무덤 자랑처럼 아이들의 있습니다.',
          overflow: TextOverflow.ellipsis));
    }

    return Scaffold(
        body: Column(children: [
          CustomAppBar(actions: [
            const CustomAppBarSearchButton(),
            CustomAppBarModeButton(
                type: CustomAppBarModeType.vertical,
                onPressed: () {
                  context.pushNamed('memoListViewPage');
                }),
            const CustomAppBarProfileButton()
          ]),
          SectionTitle(
              icon: Image.asset('assets/icons/week_view_memo.png'),
              title: '메모'),
          _MemoGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 148.0 / 124.0,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
              ),
              children: dummyMemos
                  .map((memo) => _MemoBox(
                      child: Column(children: [const _MemoMarkers(), memo])))
                  .toList())
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class MemoListViewPage extends StatelessWidget {
  static const routeName = 'memo/list';

  const MemoListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> dummyMemos = [];

    for (var i = 0; i < 10; i++) {
      dummyMemos.add(const Text(
          '하나에 가득 우는 어머니, 듯합니다. 밤을 나는 별들을 까닭입니다. 나는 노루, 가을로 이름을 패, 내 거외다. 책상을 우는 나의 별 릴케 것은 까닭입니다. 아직 내린 하나에 아침이 나의 이국 그리고 까닭입니다. 시인의 지나가는 부끄러운 슬퍼하는 있습니다. 하나에 하늘에는 않은 내 불러 무덤 자랑처럼 아이들의 있습니다.',
          overflow: TextOverflow.ellipsis));
    }

    return Scaffold(
        body: Column(children: [
          CustomAppBar(actions: [
            const CustomAppBarSearchButton(),
            CustomAppBarModeButton(
                type: CustomAppBarModeType.horizontal,
                onPressed: () {
                  context.pushNamed('memoGridViewPage');
                }),
            const CustomAppBarProfileButton()
          ]),
          SectionTitle(
              icon: Image.asset('assets/icons/week_view_memo.png'),
              title: '메모'),
          _MemoGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 312.0 / 64.0,
                mainAxisSpacing: 28,
                crossAxisSpacing: 16,
              ),
              children: dummyMemos
                  .map((memo) => _MemoBox(
                      child: Column(children: [const _MemoMarkers(), memo])))
                  .toList())
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class _MemoBox extends StatelessWidget {
  final Widget child;

  const _MemoBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: CustomTheme.groupedBackground.primary,
            borderRadius: BorderRadius.circular(12)),
        child: child);
  }
}

class _MemoMarkers extends StatelessWidget {
  const _MemoMarkers({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = markerColors.sublist(0, 4);

    return Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(bottom: 6),
        child: Wrap(
            spacing: 4,
            children: colors
                .map((color) => Container(
                    width: 14,
                    height: 14,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: color)))
                .toList()));
  }
}

class _MemoGrid extends StatelessWidget {
  final SliverGridDelegate gridDelegate;
  final List<Widget> children;

  const _MemoGrid(
      {super.key, required this.gridDelegate, required this.children});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding:
                    const EdgeInsets.only(left: 24, right: 24, bottom: 146),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate: gridDelegate,
                    itemCount: children.length,
                    itemBuilder: (gridContext, index) => children[index]))));
  }
}
