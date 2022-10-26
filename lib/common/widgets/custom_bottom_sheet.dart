import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/widgets/custom_backdrop.dart';
import 'package:flutter/material.dart';

/// 화면에 항상 떠 있는 bottom sheet입니다.
/// 드래그하여 크기를 조정할 수 있습니다.
class CustomBottomSheet extends StatefulWidget {
  final double minSize;
  final double maxSize;
  final List<double> snapSizes;
  final Widget child;

  const CustomBottomSheet(
      {super.key,
      required this.minSize,
      required this.maxSize,
      required this.snapSizes,
      required this.child});

  @override
  State<StatefulWidget> createState() {
    return _CustomBottomSheetState();
  }
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  // Rebuild 이후에도 새로 만들지 않고 재사용해야 하므로 state로 들고 있음.
  late final DraggableScrollableController _sheetController;

  late double _size;

  void _handleChange() {
    setState(() {
      _size = _sheetController.size;
    });
  }

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(_handleChange);
    _size = widget.minSize;
  }

  @override
  void dispose() {
    _sheetController.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          value: _size,
          minValue: widget.minSize,
          maxValue: widget.maxSize,
          minShowValue: widget.minSize + 0.1),
      DraggableScrollableSheet(
          controller: _sheetController,
          minChildSize: widget.minSize,
          maxChildSize: widget.maxSize,
          initialChildSize: widget.minSize,
          snapSizes: widget.snapSizes,
          snap: true,
          builder: (sheetContext, scrollController) => Container(
              decoration: decoration,
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(children: [handle, widget.child]))))
    ]);
  }
}
