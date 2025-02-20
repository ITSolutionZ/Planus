import 'package:flutter/material.dart';
import 'package:planus/views/group_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            Expanded(
              child: Consumer<NewTaskViewModel>(
                builder: (context, viewModel, _) {
                  if (viewModel.tasks.isEmpty) {
                    return const Center(child: Text("予定がありません"));
                  }
                  final tasksForSelectedDate = viewModel.tasks
                      .where((task) => isSameDay(
                          _parseDate(task.date), _selectedDay ?? _focusedDay))
                      .toList();
                  return ListView.builder(
                    itemCount: tasksForSelectedDate.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedDate[index];

                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          final taskId = task.id;

                          viewModel.deleteTask(taskId);

                          setState(() {
                            viewModel.tasks.removeWhere((t) => t.id == taskId);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${task.title} が削除されました')),
                          );
                        },
                        child: _buildTaskItem(task, viewModel),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTabSelected: (index) {
          if (index != 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (index == 0) return const HomeScreen();
                  if (index == 2) return const GroupScreen();
                  if (index == 3)
                    return const Center(child: Text('Settings Page'));
                  return const HomeScreen();
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTaskItem(model.Task task, NewTaskViewModel viewModel) {
    return Dismissible(
      key: Key(task.id.toString()), // ✅ 각 태스크를 식별하는 Key 필요
      direction: DismissDirection.endToStart, // ✅ 오른쪽 → 왼쪽으로 스와이프 가능
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        viewModel.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${task.title} を削除しました")),
        );
      },
      child: Card(
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
                  color: _getTaskColor(_parseTaskType(task.taskType)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
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
      ),
    );
  }

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

  DateTime _parseDate(dynamic date) {
    if (date is DateTime) return date;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  model.TaskType _parseTaskType(String taskType) {
    return model.TaskType.values.firstWhere(
      (e) => e.toString().split('.').last == taskType,
      orElse: () => model.TaskType.reading,
    );
  }
}
