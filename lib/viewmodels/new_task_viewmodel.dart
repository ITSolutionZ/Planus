import 'package:flutter/material.dart';
import '../models/task_model.dart';

class NewTaskViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  Repeat _repeat = Repeat.none;
  TaskType _taskType = TaskType.reading;
  String? _location;
  TimeOfDay? _alarm;
  final List<Task> _tasks = [];

  // Getter
  DateTime get selectedDate => _selectedDate;
  List<Task> get tasks => _tasks;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  Repeat get repeat => _repeat;
  TaskType get taskType => _taskType;
  String? get location => _location;
  TimeOfDay? get alarm => _alarm;

  // Setter
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    _startTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            as TimeOfDay;
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    _endTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            as TimeOfDay;

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

  void setLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

  void setAlarm(BuildContext context, TimeOfDay time) {
    _alarm = time;
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
      alarm: _alarm.toString(),
    );

    _tasks.add(newTask);
    debugPrint("Saved Task: ${newTask.toJson()}");

    notifyListeners();
  }
}
