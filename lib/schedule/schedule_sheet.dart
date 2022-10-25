import 'package:calendar/common/custom_backdrop.dart';
import 'package:calendar/common/custom_theme.dart';
import 'package:flutter/material.dart';

class ScheduleSheet extends StatefulWidget {
  static const minSize = 0.2;
  static const maxSize = 1.0;
  static final snapSizes = [minSize, 0.5, maxSize];

  final DraggableScrollableController controller;

  const ScheduleSheet({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() {
    return _ScheduleSheetState();
  }
}

class _ScheduleSheetState extends State<ScheduleSheet> {
  double _sheetSize = ScheduleSheet.minSize;

  void _handleChange() {
    setState(() {
      _sheetSize = widget.controller.size;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
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

    final header = Padding(
        padding: const EdgeInsets.only(top: 6, left: 20, right: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('다가오는 일정',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          TextButton(
              onPressed: () {},
              child: Text('편집',
                  style: TextStyle(fontSize: 14, color: CustomTheme.tint.blue)))
        ]));

    return Stack(children: [
      CustomBackdrop(
          value: _sheetSize,
          minValue: ScheduleSheet.minSize,
          maxValue: ScheduleSheet.maxSize,
          minShowValue: ScheduleSheet.minSize + 0.1),
      DraggableScrollableSheet(
          controller: widget.controller,
          minChildSize: ScheduleSheet.minSize,
          maxChildSize: ScheduleSheet.maxSize,
          initialChildSize: ScheduleSheet.minSize,
          snapSizes: ScheduleSheet.snapSizes,
          snap: true,
          builder: (sheetContext, scrollController) => Container(
              decoration: decoration,
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(children: [handle, header]))))
    ]);
  }
}
