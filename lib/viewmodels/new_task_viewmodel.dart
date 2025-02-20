import 'package:flutter/material.dart';
import '../models/task_model.dart' as model;
import '../utils/task_database.dart' as database;
import 'package:drift/drift.dart';
import 'package:table_calendar/table_calendar.dart';

class NewTaskViewModel extends ChangeNotifier {
  final database.TaskDatabase _database = database.TaskDatabase();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  model.Repeat _repeat = model.Repeat.none;
  model.TaskType _taskType = model.TaskType.reading;
  String? _location;
  TimeOfDay? _alarm;
  List<model.Task> _tasks = []; // ✅ 수정: model.Task 리스트를 사용

  //  Getter
  DateTime get selectedDate => _selectedDate;
  List<model.Task> get tasks => _tasks;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  model.Repeat get repeat => _repeat;
  model.TaskType get taskType => _taskType;
  String? get location => _location;
  TimeOfDay? get alarm => _alarm;

  //  Setter
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    _startTime = time;
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    _endTime = time;
    notifyListeners();
  }

  void setRepeat(model.Repeat repeat) {
    _repeat = repeat;
    notifyListeners();
  }

  void setTaskType(model.TaskType type) {
    _taskType = type;
    notifyListeners();
  }

  void setLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

  void setAlarm(TimeOfDay time) {
    _alarm = time;
    notifyListeners();
  }

  // DBにTaskを保存
  Future<void> saveTask(String title) async {
    final newTask = database.TasksCompanion(
      title: Value(title),
      date: Value(_selectedDate.toIso8601String().split('T')[0]),
      startTime: Value(_formatTime(_startTime)),
      endTime: Value(_formatTime(_endTime)),
      repeat: Value(_repeat.name),
      taskType: Value(_taskType.name),
      location: Value(_location ?? ""),
      alarm: Value(_alarm != null ? _formatTime(_alarm!) : ""),
      isCompleted: const Value(false),
    );

    await _database.insertTask(newTask);
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    final fetchedTasks = await _database.getAllTasks();

    _tasks = fetchedTasks
        .map((task) => model.Task(
              title: task.title,
              date: DateTime.tryParse(task.date) ?? DateTime.now(),
              startTime: _formatTime(
                _parseTime(
                  task.startTime,
                ),
              ),
              endTime: _formatTime(
                _parseTime(
                  task.endTime,
                ),
              ),
              repeat: model.Repeat.values.firstWhere(
                (e) => e.name == task.repeat,
                orElse: () => model.Repeat.none,
              ), // ✅ Enum 변환
              taskType: task.taskType,
              location: task.location,
              alarm: task.alarm,
              isCompleted: task.isCompleted,
              id: task.id,
            ))
        .toList();

    notifyListeners();
  }

// HH:mm → TimeOfDay 変換
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // 特定日の日程取得
  List<model.Task> getTasksForSelectedDate(DateTime selectedDay) {
    return _tasks.where((task) {
      final taskDate = task.date;
      return isSameDay(taskDate, selectedDay);
    }).toList();
  }

  model.TaskType _parseTaskType(String taskType) {
    return model.TaskType.values.firstWhere(
      (e) => e.toString().split('.').last == taskType,
      orElse: () => model.TaskType.reading,
    );
  }

  void deleteTask(int taskId) async {
    await _database.deleteTask(taskId);
    await fetchTasks();
  }
}
