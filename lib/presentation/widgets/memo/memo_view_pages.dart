import 'package:admob_flutter/admob_flutter.dart';
import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/presentation/providers/memos_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:calendar/presentation/widgets/common/section.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../secert/admob_id.dart';

const _gridHorizontalPadding = 24.0;
const _markerSize = 14.0;
const _markersMargin = 6.0;

class MemoGridViewPage extends StatelessWidget {
  static const routeName = 'memo/grid';
  late BannerAd banner;

  MemoGridViewPage({super.key}) {
    banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdmobId.bannerId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final memosProvider = context.watch<MemosProvider>();
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
        body: Column(children: [
          CustomAppBar(leftActions: const [
            _MemoAddButton()
          ], rightActions: [
            CustomAppBarModeButton(
                type: CustomAppBarModeType.vertical,
                onPressed: () {
                  context.pushNamed('memoListViewPage');
                }),
            const CustomAppBarSearchButton(type: PageType.memo),
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
                        Text(memoModel.content,
                            maxLines: 4, overflow: TextOverflow.ellipsis)
                      ])))
                  .toList()),
          Padding(
            padding: EdgeInsets.only(bottom: 12+bottomPadding),
            child: SizedBox(
                height: AdSize.largeBanner.height.toDouble(),
                child: AdWidget(ad: banner)),
          )
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class MemoListViewPage extends StatelessWidget {
  static const routeName = 'memo/list';
  late BannerAd banner;

  MemoListViewPage({super.key}) {
    banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdmobId.bannerId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final memosProvider = context.watch<MemosProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth - _gridHorizontalPadding * 2;
    const actionsWidth = 106.0;
    final actionsExtent = actionsWidth / itemWidth;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
        body: Column(children: [
          CustomAppBar(leftActions: const [
            _MemoAddButton()
          ], rightActions: [
            CustomAppBarModeButton(
                type: CustomAppBarModeType.horizontal,
                onPressed: () {
                  context.pushNamed('memoGridViewPage');
                }),
            const CustomAppBarSearchButton(type: PageType.memo),
          ]),
          SectionTitle(
              icon: Image.asset('assets/icons/week_view_memo.png'),
              title: '메모'),
          _MemoList(
              children: memosProvider.allMemos
                  .map((memoModel) => Slidable(
                      key: Key(memoModel.id),
                      endActionPane: ActionPane(
                          extentRatio: actionsExtent,
                          motion: const ScrollMotion(),
                          children: [
                            _MemoSlideActions(
                              onPressShare: () {
                                memosProvider.shareMemo(memoModel);
                              },
                              onPressDelete: () {
                                memosProvider.deleteMemo(memoModel.id);
                              },
                            )
                          ]),
                      child: Column(children: [
                        _MemoMarkers(memoModel: memoModel),
                        ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 64),
                            child: _MemoBox(
                                onPressed: () {
                                  context.pushNamed('memoEditPage',
                                      extra: memoModel);
                                },
                                child: Text(memoModel.content,
                                    overflow: TextOverflow.ellipsis)))
                      ])))
                  .toList()),
          Padding(
            padding: EdgeInsets.only(bottom: 12+bottomPadding),
            child: SizedBox(
                height: AdSize.largeBanner.height.toDouble(),
                child: AdWidget(ad: banner)),
          )
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class _MemoSlideActions extends StatelessWidget {
  final void Function() onPressShare;
  final void Function() onPressDelete;

  const _MemoSlideActions(
      {required this.onPressShare, required this.onPressDelete});

  @override
  Widget build(BuildContext context) {
    final memosProvider = context.watch<MemosProvider>();

    const iconSize = 16.0;

    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(top: _markersMargin + _markerSize),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              _MemoAction(
                  icon: SvgPicture.asset(
                      'assets/icons/memo_edit_page_slide_share.svg',
                      width: iconSize,
                      fit: BoxFit.scaleDown),
                  color: CustomTheme.tint.green,
                  onPressed: onPressShare),
              const SizedBox(width: 6),
              _MemoAction(
                  icon: SvgPicture.asset(
                      'assets/icons/memo_edit_page_slide_delete.svg',
                      width: iconSize,
                      fit: BoxFit.scaleDown),
                  color: CustomTheme.tint.red,
                  onPressed: onPressDelete)
            ])));
  }
}

class _MemoAction extends StatelessWidget {
  final Widget icon;
  final Color color;
  final void Function() onPressed;

  const _MemoAction(
      {required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const actionSize = 40.0;

    return Container(
        width: actionSize,
        height: actionSize,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPressed,
                child: icon)));
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
        margin: const EdgeInsets.only(bottom: _markersMargin),
        child: Wrap(
            spacing: 4,
            children: colors
                .map((color) => Container(
                    width: _markerSize,
                    height: _markerSize,
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
                padding: const EdgeInsets.only(
                    left: _gridHorizontalPadding,
                    right: _gridHorizontalPadding,
                    bottom: 146),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate: gridDelegate,
                    itemCount: children.length,
                    itemBuilder: (gridContext, index) => children[index]))));
  }
}

class _MemoList extends StatelessWidget {
  final List<Widget> children;

  const _MemoList({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: const EdgeInsets.only(
                    left: _gridHorizontalPadding,
                    right: _gridHorizontalPadding,
                    bottom: 146),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: children.length,
                    itemBuilder: (gridContext, index) => Column(children: [
                          children[index],
                          const SizedBox(height: 24)
                        ])))));
  }
}
