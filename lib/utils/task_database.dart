import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'task_database.g.dart'; // 자동 생성 파일

// ✅ 1. 테이블 정의
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()(); // 자동 증가 ID
  TextColumn get title => text()();
  TextColumn get date => text()(); // 날짜 (String 형식)
  TextColumn get startTime => text()(); // 시작 시간
  TextColumn get endTime => text()(); // 종료 시간
  TextColumn get repeat => text()(); // 반복 옵션
  TextColumn get taskType => text()(); // 작업 유형
  TextColumn get location => text().nullable()(); // 위치 (nullable)
  TextColumn get alarm => text().nullable()(); // 알람 시간 (nullable)
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

// ✅ 2. 데이터베이스 클래스 정의
@DriftDatabase(tables: [Tasks])
class TaskDatabase extends _$TaskDatabase {
  TaskDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ✅ 일정 추가
  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  // ✅ 일정 조회
  Future<List<Task>> getAllTasks() => select(tasks).get();

  // ✅ 특정 날짜의 일정 조회
  Future<List<Task>> getTasksForDate(String selectedDate) {
    return (select(tasks)..where((tbl) => tbl.date.equals(selectedDate))).get();
  }
}

// ✅ 데이터베이스 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tasks.sqlite'));
    return NativeDatabase(file);
  });
}
