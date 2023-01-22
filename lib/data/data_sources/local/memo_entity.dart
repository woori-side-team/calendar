import 'package:hive/hive.dart';

part 'memo_entity.g.dart';

@HiveType(typeId: 1)
class MemoEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  List<int> selectedColorIndices;

  MemoEntity(
      {required this.id,
      required this.title,
      required this.content,
      required this.selectedColorIndices});
}
