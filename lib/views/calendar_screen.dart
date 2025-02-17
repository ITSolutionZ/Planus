import 'package:flutter/material.dart';
import 'package:planus/views/home_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../components/custom_bottom_navigator.dart';
import '../viewmodels/new_task_viewmodel.dart';
import '../models/task_model.dart' as model;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // ✅ 캘린더 화면이 열릴 때 DB에서 일정 가져오기
    Future.delayed(Duration.zero, () {
      Provider.of<NewTaskViewModel>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.create, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'カレンダー',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.orange),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.orange),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.amberAccent.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ 일정 리스트 (Drift DB에서 가져오기)
            Expanded(
              child: Consumer<NewTaskViewModel>(
                builder: (context, viewModel, _) {
                  final tasksForSelectedDate = viewModel.tasks
                      .where(
                        (task) => isSameDay(
                          _parseDate(task.date), // ✅ String → DateTime 변환
                          _selectedDay!,
                        ),
                      )
                      .toList();

                  if (tasksForSelectedDate.isEmpty) {
                    return const Center(child: Text("予定がありません"));
                  }

                  return ListView.builder(
                    itemCount: tasksForSelectedDate.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedDate[index];
                      return _buildTaskItem(task);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Task 아이템 빌드
  Widget _buildTaskItem(model.Task task) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getTaskColor(
                  _parseTaskType(
                    task.taskType,
                  ),
                ),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              "${task.title} (${task.startTime} - ${task.endTime})",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Task 타입에 따라 색상 지정
  Color _getTaskColor(model.TaskType taskType) {
    switch (taskType) {
      case model.TaskType.reading:
        return Colors.orange;
      case model.TaskType.studying:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  // ✅ String → DateTime 변환 함수
  DateTime _parseDate(dynamic date) {
    if (date is DateTime) return date;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  // ✅ String → TimeOfDay 변환 함수
  TimeOfDay _parseTime(String time) {
    try {
      final parts = time.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  model.TaskType _parseTaskType(String taskType) {
    return model.TaskType.values.firstWhere(
      (e) => e.toString().split('.').last == taskType,
      orElse: () => model.TaskType.reading, // 기본값
    );
  }
}
