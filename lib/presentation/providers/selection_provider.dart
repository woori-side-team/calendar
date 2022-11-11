import 'package:flutter/material.dart';

class SelectionProvider with ChangeNotifier {
  var _selectedMonthDate = DateTime(2022, 11);

  DateTime get selectedMonthDate {
    return _selectedMonthDate;
  }

  set selectedMonthDate(DateTime date) {
    _selectedMonthDate = date;
    notifyListeners();
  }
}
