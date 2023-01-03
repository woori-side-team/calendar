import 'package:calendar/domain/use_cases/memo_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class MemosProvider with ChangeNotifier {
  final AddMemoUseCase _addMemoUseCase;
  final UpdateMemoUseCase _updateMemoUseCase;
  final DeleteMemoUseCase _deleteMemoUseCase;
  final GetAllMemosUseCase _getAllMemosUseCase;

  MemosProvider(this._addMemoUseCase, this._updateMemoUseCase,
      this._deleteMemoUseCase, this._getAllMemosUseCase);
}
