import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String id;
  String name;
  String user_id;
  bool? isOutput;

  Category({
    required this.id,
    required this.name,
    required this.user_id,
    this.isOutput,
  });
  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: json["id"],
      name: json["name"],
      isOutput: json["is_output"],
      user_id: json["user_id"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isOutput": isOutput,
        "user_id": user_id,
      };
  @override
  List<Object?> get props => [id, name, isOutput, user_id];
}
