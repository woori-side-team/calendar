import 'package:calendar/common/utils/debug_utils.dart';
import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/custom_bottom_sheet.dart';

/// [bottomNavigationBar]를 bottomSheet을 가진 [scaffold]보다 위에 그리는 위젯.
///
/// BottomSheet과 BottomNavigationBar를 같이 쓴다면
/// Scaffold 대신 이것을 쓸 것을 권장.
class ScaffoldOverlayBottomNavigationBar extends StatefulWidget {
  const ScaffoldOverlayBottomNavigationBar(
      {Key? key,
      required this.scaffold,
      required this.bottomNavigationBar,
      this.hasSheet = true})
      : super(key: key);

  final Scaffold scaffold;
  final CustomNavigationBar bottomNavigationBar;
  final bool hasSheet;

  @override
  State<ScaffoldOverlayBottomNavigationBar> createState() =>
      _ScaffoldOverlayBottomNavigationBarState();
}

class _ScaffoldOverlayBottomNavigationBarState
    extends State<ScaffoldOverlayBottomNavigationBar> {
  late final int _sheetIndex;

  @override
  void initState() {
    super.initState();
    var viewModel = context.read<SheetProvider>();
    viewModel.addScrollController();
    _sheetIndex = viewModel.sheetScrollControllers.length - 1;
    DebugUtils.print(
        'ScaffoldOverlayBottomNavigationBar initialize $_sheetIndex time.',
        alwaysPrint: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.hasSheet
            ? CustomBottomSheet(sheetIndex: _sheetIndex, child: widget.scaffold)
            : widget.scaffold,
        bottomNavigationBar:
            widget.bottomNavigationBar.copyWith(sheetIndex: _sheetIndex));
  }
}
