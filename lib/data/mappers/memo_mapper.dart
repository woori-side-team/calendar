import 'package:calendar/data/data_sources/local/memo_entity.dart';
import 'package:calendar/domain/models/memo_model.dart';

extension ToMemoModel on MemoEntity {
  MemoModel toMemoModel() {
    return MemoModel(
        id: id,
        title: title,
        content: content,
        selectedColorIndices: selectedColorIndices);
  }
}

extension ToMemoEntity on MemoModel {
  MemoEntity toMemoEntity() {
    return MemoEntity(
        id: id,
        title: title,
        content: content,
        selectedColorIndices: selectedColorIndices);
  }
}
