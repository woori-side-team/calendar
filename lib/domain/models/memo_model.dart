import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo_model.freezed.dart';
part 'memo_model.g.dart';

@freezed
class MemoModel with _$MemoModel {
  const factory MemoModel(
      {required String id,
      required String content,
      required List<int> selectedColorIndices}) = _MemoModel;

  factory MemoModel.fromJson(Map<String, Object?> json) =>
      _$MemoModelFromJson(json);
}
