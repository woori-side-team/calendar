import 'package:calendar/common/styles/custom_theme.dart';
import 'package:calendar/common/widgets/custom_backdrop.dart';
import 'package:flutter/material.dart';

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
  late double _size;
  late final DraggableScrollableController _controller;

  void _handleChange() {
    setState(() {
      _size = _controller.size;
    });
  }

  @override
  void initState() {
    super.initState();
    _size = widget.minSize;
    _controller = DraggableScrollableController();
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
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
          controller: _controller,
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
