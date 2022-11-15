import 'package:calendar/domain/models/schedule_model.dart';
import 'package:flutter/material.dart';

import '../../common/utils/custom_date_utils.dart';
import '../widgets/common/custom_theme.dart';

class SheetProvider with ChangeNotifier {
  // page마다 sheet는 다 다른 시트이기 때문에,
  // DraggableScrollableController 하나를 다같이 쓰면
  // 이미 할당된 controller라면서 error가 뜬다.
  // 그래서 page마다 다 다른 controller를 할당
  final List<DraggableScrollableController> _sheetScrollControllers = [];
  Color _editColor = CustomTheme.gray.gray3;

  @override
  void dispose() {
    for (var controller in _sheetScrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addScrollController() {
    _sheetScrollControllers.add(DraggableScrollableController());
  }

  List<DraggableScrollableController> get sheetScrollControllers =>
      _sheetScrollControllers;

  Color get editColor => _editColor;

  void setEditColor(int scrollControllerIndex, double size) {
    if (_sheetScrollControllers[scrollControllerIndex].isAttached &&
        _sheetScrollControllers[scrollControllerIndex].size >= 0.5) {
      _editColor = CustomTheme.tint.blue;
    } else {
      _editColor = CustomTheme.gray.gray3;
    }
    notifyListeners();
  }

  /// DateTime.now()와 target이 며칠 차이나는지 반환
  int getDCount(DateTime target) {
    final startDate = DateTime(target.year, target.month, target.day);
    final nowDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return startDate.difference(nowDate).inDays;
  }

  double getMaxSheetSize(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;
    double totalHeight = MediaQuery.of(context).size.height;
    double safeTotalRatio = safePadding / totalHeight;
    return 1.0 - safeTotalRatio;
  }

  bool isScheduleToShow(ScheduleModel schedule) {
    bool isDCountZeroOrMoreThanZero(ScheduleModel schedule) {
      final dCount = getDCount(schedule.start);
      return dCount >= 0;
    }

    final now = CustomDateUtils.getNow();

    return schedule.start.month == now.month &&
        isDCountZeroOrMoreThanZero(schedule);
  }
}
