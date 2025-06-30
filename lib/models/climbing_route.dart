import 'package:hive/hive.dart';

part 'climbing_route.g.dart';

@HiveType(typeId: 0)
class ClimbingRoute extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String location;

  @HiveField(2)
  String rockType;

  @HiveField(3)
  String? complexity;

  @HiveField(4)
  String? height;

  @HiveField(5)
  String? description;

  @HiveField(6)
  String? imagePath;

  @HiveField(7)
  DateTime createdAt;

  ClimbingRoute({
    required this.name,
    required this.location,
    required this.rockType,
    this.complexity,
    this.height,
    this.description,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
