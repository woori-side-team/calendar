import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/presentation/providers/memos_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:calendar/presentation/widgets/common/section.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemoGridViewPage extends StatelessWidget {
  static const routeName = 'memo/grid';

  const MemoGridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final memosProvider = context.watch<MemosProvider>();

    return Scaffold(
        body: Column(children: [
          CustomAppBar(leftActions: const [
            _MemoAddButton()
          ], rightActions: [
            const CustomAppBarSearchButton(type: PageType.memo),
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
              children: memosProvider.allMemos
                  .map((memoModel) => _MemoBox(
                      onPressed: () {
                        context.pushNamed('memoEditPage', extra: memoModel);
                      },
                      child: Column(children: [
                        _MemoMarkers(memoModel: memoModel),
                        Text(memoModel.content, overflow: TextOverflow.ellipsis)
                      ])))
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
    final memosProvider = context.watch<MemosProvider>();

    return Scaffold(
        body: Column(children: [
          CustomAppBar(leftActions: const [
            _MemoAddButton()
          ], rightActions: [
            const CustomAppBarSearchButton(type: PageType.memo),
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
              children: memosProvider.allMemos
                  .map((memoModel) => Column(children: [
                        _MemoMarkers(memoModel: memoModel),
                        _MemoBox(
                            onPressed: () {
                              context.pushNamed('memoEditPage',
                                  extra: memoModel);
                            },
                            child: Text(memoModel.content,
                                overflow: TextOverflow.ellipsis))
                      ]))
                  .toList())
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class _MemoAddButton extends StatelessWidget {
  const _MemoAddButton();

  void _handlePress(MemosProvider memosProvider) async {
    await memosProvider.generateNewMemo();
  }

  @override
  Widget build(BuildContext context) {
    final memosProvider = context.watch<MemosProvider>();

    return CustomAppBarAddButton(
        onPressed: () {
          _handlePress(memosProvider);
        },
        label: '메모 추가');
  }
}

class _MemoBox extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const _MemoBox({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: CustomTheme.groupedBackground.primary,
                borderRadius: BorderRadius.circular(12)),
            child: child));
  }
}

class _MemoMarkers extends StatelessWidget {
  final MemoModel memoModel;

  const _MemoMarkers({super.key, required this.memoModel});

  @override
  Widget build(BuildContext context) {
    final colors =
        memoModel.selectedColorIndices.map((index) => markerColors[index]);

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
