import 'dart:convert';

class UserInfoModel {
  final int? id;
  final String name;

  UserInfoModel({this.id, required this.name});

  factory UserInfoModel.fromMap(Map<String, dynamic> json) => UserInfoModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
