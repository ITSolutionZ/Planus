import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'task_database.g.dart';

// table
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get date => text()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get repeat => text()();
  TextColumn get taskType => text()();
  TextColumn get location => text().nullable()();
  TextColumn get alarm => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

// db class
@DriftDatabase(tables: [Tasks])
class TaskDatabase extends _$TaskDatabase {
  TaskDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future<List<Task>> getTasksForDate(String selectedDate) {
    return (select(tasks)..where((tbl) => tbl.date.equals(selectedDate))).get();
  }

  deleteTask(int taskId) {}
}

// db connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tasks.sqlite'));
    return NativeDatabase(file);
  });
}
