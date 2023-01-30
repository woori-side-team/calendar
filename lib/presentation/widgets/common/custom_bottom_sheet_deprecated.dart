import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_backdrop.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 화면에 항상 떠 있는 bottom sheet입니다.
/// 드래그하여 크기를 조정할 수 있습니다.
class CustomBottomSheet_deprecated extends StatefulWidget {
  final double minSize;
  final double maxSize;
  final List<double> snapSizes;
  final Widget child;
  final int sheetIndex;

  const CustomBottomSheet_deprecated(
      {super.key,
      required this.minSize,
      required this.maxSize,
      required this.snapSizes,
      required this.child,
      required this.sheetIndex});

  @override
  State<StatefulWidget> createState() {
    return _CustomBottomSheet_deprecatedState();
  }
}

class _CustomBottomSheet_deprecatedState extends State<CustomBottomSheet_deprecated> {

  void _handleChange(SheetProvider viewModel) {

      viewModel.size = viewModel.sheetScrollControllers[widget.sheetIndex].panelPosition;
      viewModel.setEditColor_deprecated(widget.sheetIndex, viewModel.size);

  }

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SheetProvider>();
    viewModel.addScrollController();
    final scrollController =
        viewModel.sheetScrollControllers[widget.sheetIndex];

  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SheetProvider>();

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

    return Stack(children: [
      CustomBackdrop(
          value: viewModel.size,
          minValue: widget.minSize,
          maxValue: widget.maxSize,
          minShowValue: widget.minSize + 0.1),
      DraggableScrollableSheet(
          controller: DraggableScrollableController(),
          minChildSize: widget.minSize,
          maxChildSize: widget.maxSize,
          initialChildSize: widget.minSize,
          snapSizes: widget.snapSizes,
          snap: true,
          builder: (sheetContext, scrollController) => Container(
              decoration: decoration,
              child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: scrollController,
                  child: Column(children: [
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
                    widget.child
                  ]))))
    ]);
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
