import 'package:calendar/common/utils/debug_utils.dart';
import 'package:calendar/data/data_sources/local/memo_entity.dart';
import 'package:calendar/data/mappers/memo_mapper.dart';
import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/domain/repositories/memo_repository.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MemoRepository)
class MemoRepositoryImpl implements MemoRepository {
  final _tableName = 'memos';

  @override
  Future<MemoModel?> getMemoByID(String id) async {
    final box = await Hive.openBox<MemoEntity>(_tableName);
    return box.get(id)?.toMemoModel();
  }

  @override
  Future<void> addMemo(MemoModel memoModel) async {
    final box = await Hive.openBox<MemoEntity>(_tableName);
    await box.put(memoModel.id, memoModel.toMemoEntity());
  }

  @override
  Future<void> updateMemo(MemoModel memoModel) async {
    final box = await Hive.openBox<MemoEntity>(_tableName);
    await box.put(memoModel.id, memoModel.toMemoEntity());
  }

  @override
  Future<void> deleteMemo(String id) async {
    final box = await Hive.openBox<MemoEntity>(_tableName);

    if (box.get(id) == null) {
      DebugUtils.print(
          '[MemoRepositoryImpl] Got a deletion request but the item doesn\'t exist!');
    }

    await box.delete(id);
  }

  @override
  Future<List<MemoModel>> getAllMemos() async {
    final box = await Hive.openBox<MemoEntity>(_tableName);
    var entities = box.values.toList();
    List<MemoModel> models = [];
    for (var item in entities) {
      models.add(item.toMemoModel());
    }
    return models;
  }

  @override
  Future<void> deleteAllMemos() async {
    final box = await Hive.openBox<MemoEntity>(_tableName);
    await box.clear();
  }
}
