import 'package:calendar/data/data_sources/local/memo_entity.dart';
import 'package:calendar/data/repositories_impl/memo_repository_impl.dart';
import 'package:calendar/domain/models/memo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  test('memo repo impl test', () async {
    Hive.init('Test');
    Hive.registerAdapter(MemoEntityAdapter());
    final repository = MemoRepositoryImpl();

    const model1 =
        MemoModel(id: '1', content: '안녕하세요', selectedColorIndices: [0, 1, 2]);

    // Test insert.
    await repository.addMemo(model1);
    var allModels = await repository.getAllMemos();
    expect(allModels[0].content, model1.content);

    // Test update.
    const newContent = 'Hello';
    await repository.updateMemo(model1.copyWith(content: newContent));
    allModels = await repository.getAllMemos();
    expect(allModels[0].content, newContent);

    // Test delete.
    await repository.deleteMemo(model1.id);
    allModels = await repository.getAllMemos();
    expect(allModels.length, 0);
  });
}
