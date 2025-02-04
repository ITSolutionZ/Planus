import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/local_notifications_helper.dart';

class NewTaskViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  Repeat _repeat = Repeat.none;
  TaskType _taskType = TaskType.reading;
  String? _location;
  String? _alarm;

  // Getter
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  Repeat get repeat => _repeat;
  TaskType get taskType => _taskType;
  String? get location => _location;
  String? get alarm => _alarm;

  // Setter
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

  void setRepeat(Repeat repeat) {
    _repeat = repeat;
    notifyListeners();
  }

  void setTaskType(TaskType type) {
    _taskType = type;
    notifyListeners();
  }

  void setLocation(String? loc) {
    _location = loc;
    notifyListeners();
  }

  void setAlarm(BuildContext context, TimeOfDay time) {
    _alarm =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    LocalNotificationsHelper.scheduleNotification(
      context,
      1, // id
      "タスクリマインダー",
      "予定されたタスクの時間です！",
      time,
      _repeat,
    );

    notifyListeners();
  }

  void saveTask() {
    Task newTask = Task(
      title: "New Task",
      date: _selectedDate,
      startTime: '${_startTime.hour}:${_startTime.minute}',
      endTime: '${_endTime.hour}:${_endTime.minute}',
      repeat: _repeat,
      taskType: _taskType.name,
      location: _location,
      alarm: _alarm,
    );
    debugPrint("Saved Task: ${newTask.toJson()}");
  }
}
