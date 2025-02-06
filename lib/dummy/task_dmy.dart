import '../models/task_model.dart';

final List<Task> dummyTasks = [
  Task(
    title: "読書する",
    date: DateTime.now(),
    startTime: "09:00",
    endTime: "10:00",
    repeat: Repeat.daily,
    taskType: TaskType.reading.name,
    location: "カフェ",
    alarm: "08:50",
  ),
  Task(
    title: "プログラミング学習",
    date: DateTime.now(),
    startTime: "14:00",
    endTime: "16:00",
    repeat: Repeat.weekly,
    taskType: TaskType.studying.name,
    location: "自宅",
    alarm: "13:50",
  ),
];
