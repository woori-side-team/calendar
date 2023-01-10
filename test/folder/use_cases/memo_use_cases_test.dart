import 'package:calendar/common/di/di.dart';
import 'package:calendar/data/data_sources/local/memo_entity.dart';
import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/domain/use_cases/memo_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  Hive.init('Test');
  Hive.registerAdapter(MemoEntityAdapter());

  test('memo use case test', () async {
    final addMemoUseCase = getIt<AddMemoUseCase>();
    final getAllMemosUseCase = getIt<GetAllMemosUseCase>();
    final updateMemoUseCase = getIt<UpdateMemoUseCase>();
    final deleteMemoUseCase = getIt<DeleteMemoUseCase>();

    const model1 =
        MemoModel(id: '1', content: '안녕하세요', selectedColorIndices: [0, 1, 2]);

    // Test insert.
    await addMemoUseCase(model1);
    var allModels = await getAllMemosUseCase();
    expect(allModels[0].content, model1.content);

    // Test update.
    const newContent = 'Hello';
    await updateMemoUseCase(model1.copyWith(content: newContent));
    allModels = await getAllMemosUseCase();
    expect(allModels[0].content, newContent);

    // Test delete.
    await deleteMemoUseCase(model1.id);
    allModels = await getAllMemosUseCase();
    expect(allModels.length, 0);
  });
}
