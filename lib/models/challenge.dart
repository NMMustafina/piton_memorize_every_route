import 'package:hive/hive.dart';

part 'challenge.g.dart';

@HiveType(typeId: 1)
class Challenge extends HiveObject {
  @HiveField(0)
  int routeKey;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime endTime;

  @HiveField(3)
  bool? completed;

  Challenge({
    required this.routeKey,
    required this.startTime,
    required this.endTime,
    this.completed,
  });
}
