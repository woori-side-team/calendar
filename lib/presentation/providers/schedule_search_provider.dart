import 'dart:async';

import 'package:calendar/domain/use_cases/schedule_use_cases.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/schedule_model.dart';

@injectable
class ScheduleSearchProvider with ChangeNotifier {
  Timer? _debounce;
  final SearchScheduleUseCase _searchScheduleUseCase;
  final List<ScheduleModel> _searched = [];
  final TextEditingController _textEditingController = TextEditingController();

  List<ScheduleModel> get searched => _searched;

  TextEditingController get textEditingController => _textEditingController;

  ScheduleSearchProvider(this._searchScheduleUseCase);

  Future<void> searchSchedules(String inputString) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      _searched.clear();
      _searched.addAll(await _searchScheduleUseCase(inputString));
      notifyListeners();
    });
  }
}
