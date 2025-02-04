import 'package:planus/models/group_model.dart';

List<Group> mockGroups = [
  Group(
    id: 1,
    name: "Flutter Study",
    description: "FlutterとDartを勉強する",
    category: Category.studing,
    members: 3,
    imageUrl: "https://via.placeholder.com/150",
    hashtags: ["Flutter", "Dart", "開発"],
    joinmembers: ["user1", "user2", "user3"],
  ),
  Group(
    id: 2,
    name: "読書クラブ",
    description: "1ヶ月に1冊本を読む",
    category: Category.reading,
    members: 5,
    imageUrl: "https://via.placeholder.com/150",
    hashtags: ["読書", "歴史", "学習"],
    joinmembers: ["userA", "userB"],
  ),
];
