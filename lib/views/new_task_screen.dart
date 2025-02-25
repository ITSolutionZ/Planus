import 'package:flutter/material.dart';
import 'package:planus/components/custom_bottom_navigator.dart';
import 'package:planus/views/calendar_screen.dart';
import 'package:planus/views/group_screen.dart';
import 'package:planus/views/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/new_task_viewmodel.dart';
import '../components/custom_button.dart';
import '../models/task_model.dart';
import '../utils/format_time.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  // ignore: prefer_final_fields
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final TextEditingController taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NewTaskViewModel>().fetchTasks());
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '日程を追加',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => NewTaskViewModel(),
        lazy: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<NewTaskViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendar(viewModel),
                  const SizedBox(height: 10),
                  TextField(
                    controller: taskTitleController,
                    decoration: const InputDecoration(
                      labelText: 'タスク名',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTimePicker(
                      context, 'Starts', viewModel.startTime, true, viewModel),
                  _buildTimePicker(
                      context, 'Ends', viewModel.endTime, false, viewModel),
                  _buildRepeatPicker(context, viewModel),
                  _buildTaskTypePicker(context, viewModel),
                  _buildLocationPicker(context, viewModel),
                  _buildAlarmPicker(context, viewModel),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Save',
                    onPressed: () {
                      if (taskTitleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                            'タスク名を入力してください',
                          )),
                        );
                        return;
                      }
                      viewModel.saveTask(taskTitleController.text);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalendarScreen(),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ],
              );
            },
          ),
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

  Widget _buildCalendar(NewTaskViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: TableCalendar(
          availableGestures: AvailableGestures.horizontalSwipe,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerPadding: EdgeInsets.symmetric(
              vertical: 4,
            ),
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
          ),
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: viewModel.selectedDate,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(
            viewModel.selectedDate,
            day,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              viewModel.setDate(selectedDay);
              _calendarFormat = CalendarFormat.week;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              viewModel.setDate(focusedDay);
              _calendarFormat = CalendarFormat.month;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label, TimeOfDay time,
      bool isStart, NewTaskViewModel viewModel) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.orange,
        ),
      ),
      trailing: Text(time.format(context)),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (pickedTime != null) {
          isStart
              ? viewModel.setStartTime(pickedTime)
              : viewModel.setEndTime(pickedTime);
        }
      },
    );
  }

  Widget _buildRepeatPicker(BuildContext context, NewTaskViewModel viewModel) {
    return ListTile(
      title: const Text(
        'Repeat',
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
      trailing: DropdownButton<Repeat>(
        value: viewModel.repeat,
        items: Repeat.values
            .map(
              (repeat) => DropdownMenuItem(
                value: repeat,
                child: Text(repeat.name),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) viewModel.setRepeat(value);
        },
      ),
    );
  }

  Widget _buildTaskTypePicker(
      BuildContext context, NewTaskViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTaskTypeButton(
          context,
          TaskType.reading,
          Colors.orange,
          viewModel,
        ),
        _buildTaskTypeButton(
          context,
          TaskType.studying,
          Colors.green,
          viewModel,
        ),
      ],
    );
  }

  Widget _buildTaskTypeButton(
    BuildContext context,
    TaskType type,
    Color color,
    NewTaskViewModel viewModel,
  ) {
    bool isSelected = viewModel.taskType == type;
    isSelected
        ? ElevatedButton(
            onPressed: () => viewModel.setTaskType(type),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? color : Colors.grey[300],
              elevation: isSelected ? 4.0 : 0,
            ),
            child: Text(
              type.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black26,
              ),
            ),
          )
        : OutlinedButton(
            onPressed: () => viewModel.setTaskType(type),
            child: const Text('aaa'));
  }

  Widget _buildLocationPicker(
    BuildContext context,
    NewTaskViewModel viewModel,
  ) {
    return ListTile(
      title: const Text(
        '場所選択',
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
      trailing: Text(
        viewModel.location ?? '未設定',
      ),
      onTap: () async {
        viewModel.setLocation('指定した場所');
      },
    );
  }

// 現在、AlarmはString型で保存されているため、TimeOfDay型に変換する必要がある。
  Widget _buildAlarmPicker(
    BuildContext context,
    NewTaskViewModel viewModel,
  ) {
    return ListTile(
      title: const Text(
        'アラーム',
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
      trailing: Text(
        viewModel.alarm != null
            ? formatTimeOfDay(context, viewModel.alarm!)
            : '未設定',
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: viewModel.alarm ?? TimeOfDay.now(),
        );

        if (pickedTime != null && context.mounted) {
          viewModel.setAlarm(pickedTime);
        }
      },
    );
  }

  String _formatAlarmTime(BuildContext context, TimeOfDay alarm) {
    return alarm.format(context);
  }

  Widget _buildTaskList(NewTaskViewModel viewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.tasks.length,
        itemBuilder: (context, index) {
          final task = viewModel.tasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: ListTile(
              title: Text(
                task.title,
              ),
              subtitle: Text(
                '${task.startTime} - ${task.endTime} / ${task.location ?? "未設定"}',
              ),
              trailing: Text(
                task.repeat.name,
              ),
            ),
          );
        },
      ),
    );
  }
}
