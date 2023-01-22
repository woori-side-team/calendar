import 'package:calendar/domain/models/memo_model.dart';

abstract class MemoRepository {
  Future<MemoModel?> getMemoByID(String id);

  Future<void> addMemo(MemoModel memoModel);

  Future<void> updateMemo(MemoModel memoModel);

  Future<void> deleteMemo(String id);

  Future<List<MemoModel>> getAllMemos();

  Future<void> deleteAllMemos();
}
