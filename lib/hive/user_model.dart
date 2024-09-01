import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)  // Ensure this typeId is unique
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  late final String image;

  // constructor
  UserModel({
    required this.uid,
    required this.name,
    required this.image,
  });
}
