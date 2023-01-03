import 'package:hive/hive.dart';

part 'memo_entity.g.dart';

@HiveType(typeId: 1)
class MemoEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  List<int> selectedColorIndices;

  MemoEntity(
      {required this.id,
      required this.content,
      required this.selectedColorIndices});
}
