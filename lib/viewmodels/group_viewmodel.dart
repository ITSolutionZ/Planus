import 'package:flutter/material.dart';

class Group {
  final String name;
  final String imagePath;
  final List<String> tags;

  Group({required this.name, required this.imagePath, required this.tags});
}

class GroupViewModel extends ChangeNotifier {
  List<Group> _newGroups = [];
  List<Group> _limitedSeatsGroups = [];
  List<Group> _friendsGroups = [];

  List<Group> get newGroups => _newGroups;
  List<Group> get limitedSeatsGroups => _limitedSeatsGroups;
  List<Group> get friendsGroups => _friendsGroups;

  void fetchGroups() {
    _newGroups = [
      Group(
          name: "履歴書グループ",
          imagePath: "assets/images/group1.jpg",
          tags: ["履歴書", "自己PR"]),
      Group(
          name: "中国語グループ",
          imagePath: "assets/images/group2.jpg",
          tags: ["中国語", "China"]),
      Group(
          name: "週末コーディング",
          imagePath: "assets/images/group3.jpg",
          tags: ["コーディング"]),
    ];

    _limitedSeatsGroups = [
      Group(
          name: "履歴書グループ",
          imagePath: "assets/images/group1.jpg",
          tags: ["履歴書", "自己PR"]),
      Group(
          name: "中国語グループ",
          imagePath: "assets/images/group2.jpg",
          tags: ["中国語", "China"]),
      Group(
          name: "週末コーディング",
          imagePath: "assets/images/group3.jpg",
          tags: ["コーディング"]),
    ];

    _friendsGroups = [
      Group(
          name: "履歴書グループ",
          imagePath: "assets/images/group1.jpg",
          tags: ["履歴書", "自己PR"]),
      Group(
          name: "中国語グループ",
          imagePath: "assets/images/group2.jpg",
          tags: ["中国語", "China"]),
      Group(
          name: "週末コーディング",
          imagePath: "assets/images/group3.jpg",
          tags: ["コーディング"]),
    ];

    notifyListeners();
  }
}
