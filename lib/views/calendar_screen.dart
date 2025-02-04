import 'package:flutter/material.dart';
import 'package:planus/views/home_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/custom_bottom_navigator.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> _taskMap = {
    DateTime.now(): [
      {'title': 'Task 1 タスク1', 'color': Colors.orange},
      {'title': 'Task 2 タスク2', 'color': Colors.green},
    ],
    DateTime(2023, 12, 25): [
      {'title': 'クリスマスイベント', 'color': Colors.red},
    ],
  };

  List<Map<String, dynamic>> getTasksForDay(DateTime day) {
    return _taskMap[DateTime(day.year, day.month, day.day)] ?? [];
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
              child: ListView.builder(
                itemCount: getTasksForDay(_selectedDay ?? _focusedDay).length,
                itemBuilder: (context, index) {
                  final task =
                      getTasksForDay(_selectedDay ?? _focusedDay)[index];
                  return _buildTaskItem(task['title'], task['color']);
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
                  if (index == 2) {
                    return const Center(
                        child: Text('Friends Page')); // dummy page
                  }
                  if (index == 3) {
                    return const Center(
                        child: Text('Settings Page')); // dummy page
                  }
                  return const HomeScreen();
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTaskItem(String task, Color color) {
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
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              task,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
