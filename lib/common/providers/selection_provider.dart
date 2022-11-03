import 'package:flutter/material.dart';

class SelectionProvider with ChangeNotifier {
  var _selectedMonthDate = DateTime(2022, 11);

  getSelectedMonthDate() {
    return _selectedMonthDate;
  }

  setSelectedMonthDate(DateTime date) {
    _selectedMonthDate = date;
    notifyListeners();
  }
}