import 'dart:async';

import 'package:calendar/domain/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../common/utils/custom_date_utils.dart';
import '../widgets/common/custom_theme.dart';

enum SheetMode { edit, view }

class SheetProvider with ChangeNotifier {
  // page마다 sheet는 다 다른 시트이기 때문에,
  // DraggableScrollableController 하나를 다같이 쓰면
  // 이미 할당된 controller라면서 error가 뜬다.
  // 그래서 page마다 다 다른 controller를 할당
  final List<PanelController> _sheetScrollControllers = [];
  final Color disableColor = CustomTheme.gray.gray3;
  final List<Color> _editColors = [CustomTheme.gray.gray3];
  final List<SheetMode> _sheetModes = [SheetMode.view];
  Timer? _debounce;
  double _size = 0.03;

  double get size => _size;

  set size(double value){
    _size = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void addScrollController() {
    _sheetScrollControllers.add(PanelController());
    _editColors.add(disableColor);
    _sheetModes.add(SheetMode.view);
  }

  List<PanelController> get sheetScrollControllers =>
      _sheetScrollControllers;

  List<Color> get editColors => _editColors;

  List<SheetMode> get sheetModes => _sheetModes;

  void setEditColor_deprecated(int scrollControllerIndex, double size) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      if (_sheetScrollControllers[scrollControllerIndex].isAttached &&
          !_sheetScrollControllers[scrollControllerIndex].isPanelClosed) {
        _editColors[scrollControllerIndex] = CustomTheme.tint.blue;
      } else {
        _editColors[scrollControllerIndex] = CustomTheme.gray.gray3;
        // 바텀시트가 최하단으로 내려가면 edit mode 해제
        setSheetViewMode(scrollControllerIndex);
      }
      notifyListeners();
    });
  }

  void setSheetViewMode(int scrollControllerIndex) {
    _sheetModes[scrollControllerIndex] = SheetMode.view;
    notifyListeners();
  }

  void setSheetEditMode(int scrollControllerIndex) {
    _sheetModes[scrollControllerIndex] = SheetMode.edit;
    notifyListeners();
  }

  double getMaxSheetSize_deprecated(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;
    double totalHeight = MediaQuery.of(context).size.height;
    double safeTotalRatio = safePadding / totalHeight;
    return 1.0 - safeTotalRatio;
  }

  double getMaxSheetSize(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;
    double totalHeight = MediaQuery.of(context).size.height;
    double bottomNavigationHeight = 100;
    return totalHeight - safePadding - bottomNavigationHeight;
  }

  bool isScheduleToShow(ScheduleModel schedule) {
    bool isDCountZeroOrMoreThanZero(ScheduleModel schedule) {
      final dCount = CustomDateUtils.getDCount(schedule.start);
      return dCount >= 0;
    }

    final now = CustomDateUtils.getNow();

    return schedule.start.month == now.month &&
        isDCountZeroOrMoreThanZero(schedule);
  }

  void moveSheetWithButton(int scrollControllerIndex) {
    if(_sheetScrollControllers[scrollControllerIndex].isPanelClosed){
      _sheetScrollControllers[scrollControllerIndex].animatePanelToPosition(0.5);
    }else{
      _sheetScrollControllers[scrollControllerIndex].animatePanelToPosition(0);
    }
    setEditColor_deprecated(scrollControllerIndex, 10);
  }

  void closeSheet(int scrollControllerIndex) {
    _sheetScrollControllers[scrollControllerIndex].animatePanelToPosition(0);
    notifyListeners();
  }
}
