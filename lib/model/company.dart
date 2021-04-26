import 'package:flutter/material.dart';

class Company {
  List<User> data;
  Company.fromJson(List value) {
    if (value != null) {
      data = List<User>();
      value.forEach((element) {
        data.add(User.fromJson(element));
      });
    }
  }
}

class User {
  String id;
  String createdAt;
  String firstName;
  String lastName;
  String team;
  String avatar;

  User.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    createdAt = data["createdAt"];
    firstName = data["first_name"];
    lastName = data["last_name"];
    team = data["team"];
    avatar = data["avatar"];
  }

  User.toJson() {
    Map<String, String> data;
    data["id"] = id;
    data["createdAt"] = createdAt;
    data["firstName"] = firstName;
    data["lastName"] = lastName;
    data["team"] = team;
    data["avatar"] = avatar;
  }
}
