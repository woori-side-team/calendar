import 'package:calendar/common/utils/custom_string_utils.dart';
import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/domain/use_cases/memo_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

@injectable
class MemosProvider with ChangeNotifier {
  final GetMemoByIdUseCase _getMemoByIdUseCase;
  final AddMemoUseCase _addMemoUseCase;
  final UpdateMemoUseCase _updateMemoUseCase;
  final DeleteMemoUseCase _deleteMemoUseCase;
  final GetAllMemosUseCase _getAllMemosUseCase;
  final DeleteAllMemosUseCase _deleteAllMemosUseCase;

  List<MemoModel> _memosCache = [];

  MemosProvider(
      this._getMemoByIdUseCase,
      this._addMemoUseCase,
      this._updateMemoUseCase,
      this._deleteMemoUseCase,
      this._getAllMemosUseCase,
      this._deleteAllMemosUseCase) {
    (() async {
      await _loadData();
      notifyListeners();
    })();
  }

  List<MemoModel> get allMemos => _memosCache;

  Future<MemoModel?> getMemoByID(String id) async {
    return await _getMemoByIdUseCase(id);
  }

  Future<void> generateNewMemo() async {
    final now = DateTime.now();

    const title = '메모';
    final content =
        '메모 ${now.year}.${now.month}.${now.day} ${now.hour}:${now.minute}:${now.second}';

    final memoModel = MemoModel(
        id: CustomStringUtils.generateID(),
        title: title,
        content: content,
        selectedColorIndices: [0]);

    await _addMemoUseCase(memoModel);
    await _loadData();
    notifyListeners();
  }

  Future<void> updateMemo(MemoModel memoModel) async {
    await _updateMemoUseCase(memoModel);
    await _loadData();
    notifyListeners();
  }

  Future<void> deleteMemo(String id) async {
    await _deleteMemoUseCase(id);
    await _loadData();
    notifyListeners();
  }

  Future<void> deleteAllMemos() async {
    await _deleteAllMemosUseCase();
    await _loadData();
    notifyListeners();
  }

  Future<void> shareMemo(MemoModel memoModel) async {
    await Share.share(memoModel.content, subject: memoModel.title);
  }

  Future<void> _loadData() async {
    _memosCache = await _getAllMemosUseCase();
  }
}
