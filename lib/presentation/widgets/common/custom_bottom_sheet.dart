import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../secert/admob_id.dart';
import '../schedule/schedule_sheet.dart';

class CustomBottomSheet extends StatelessWidget {
  Widget child;
  int sheetIndex;
  late final BannerAd banner;

  CustomBottomSheet(
      {super.key, required this.child, required this.sheetIndex}) {
    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdmobId.bannerId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SheetProvider>();

    return Material(
      child: SlidingUpPanel(
        footer: Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            color: CustomTheme.background.primary,
            width: MediaQuery.of(context).size.width,
            height: AdSize.banner.height.toDouble() + 50,
            child: AdWidget(ad: banner)),
        snapPoint: 0.5,
        controller: viewModel.sheetScrollControllers[sheetIndex],
        minHeight: AdSize.largeBanner.height.toDouble() + 20,
        maxHeight: viewModel.getMaxSheetSize(context),
        backdropEnabled: true,
        panelBuilder: (ScrollController sc) {
          final decoration = BoxDecoration(
              color: CustomTheme.background.primary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, -6),
                    blurRadius: 16,
                    color: Color.fromARGB(128, 174, 174, 178))
              ]);

          final handle = Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CustomTheme.gray.gray4,
                ),
              ),
            ]),
          );
          return Container(
              decoration: decoration,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: sc,
                child: Column(
                  children: [
                    Tooltip(
                        showDuration: const Duration(seconds: 5),
                        padding: const EdgeInsets.only(
                            top: 6, bottom: 10, left: 11, right: 11),
                        message: '해당 슬라이드를 위로 당기면, 다가오는 일정을 확인할 수 '
                            '있고 일정을 추가할 수도 있습니다.',
                        textStyle: TextStyle(color: CustomTheme.scale.scale1),
                        decoration: ShapeDecoration(
                            shape: const ToolTipCustomShape(),
                            color: CustomTheme.scale.scale10.withOpacity(0.7)),
                        preferBelow: false,
                        verticalOffset: -10,
                        child: handle),
                    const ScheduleSheet(),
                  ],
                ),
              ));
        },
        body: child,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
    );
  }
}

class ToolTipCustomShape extends ShapeBorder {
  final bool usePadding;

  const ToolTipCustomShape({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect =
        Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 20));
    return Path()
      ..addRect(rect)
      ..moveTo(rect.bottomCenter.dx - 6, rect.bottomCenter.dy)
      ..relativeLineTo(6, 9)
      ..relativeLineTo(6, -9)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
