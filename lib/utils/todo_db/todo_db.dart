import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:todo_netzlech/model/task_model/task_model.dart';
import 'package:todo_netzlech/utils/extension.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDocDir.path, 'netzlech_todo.db');
    DatabaseFactory dbFactory = databaseFactoryIo;

    // Open the database
    return await dbFactory.openDatabase(
      dbPath,
      version: 1,
    );
  }
}

@i.lazySingleton
@i.injectable
class TodoHelper {
  final Database db;

  TodoHelper(this.db);

  final _store = StoreRef<String, List>.main();

  // Insert or Update TaskModel
  Future<void> insertTask(TaskModel task) async {
    final date = task.createdAt.toFormattedString();
    final existingData = await _store.record(date).get(db);
    if (existingData == null) {
      await _store.record(date).put(db, [task.toMap()]);
    } else {
      List existing = List.from(existingData);
      existing.add(task.toMap());
      await _store.record(date).put(db, existing);
    }
  }

// Add this function outside your class
  List<TaskModel> _parseTaskData(dynamic data) {
    if (data == null) return [];
    return List<TaskModel>.from(data.map((task) => TaskModel.fromMap(task)));
  }

// Fetch Tasks for a Specific Date with multi-threading
  Future<List<TaskModel>> fetchTasks(DateTime val) async {
    final date = val.toFormattedString();
    final data = await _store.record(date).get(db);
    // Use the compute function to parse data in a separate thread
    final tasks = await compute(_parseTaskData, data);
    return tasks;
  }

  // Update a Specific TaskModel by ID for a Specific Date
  Future<void> updateTask(TaskModel updatedTask) async {
    final date = updatedTask.createdAt.toFormattedString();
    final existingData = await _store.record(date).get(db);

    if (existingData != null) {
      // Convert existing data to a List of Maps
      List<Map<String, dynamic>> existing = List<Map<String, dynamic>>.from(existingData);

      // Find the task by ID
      final taskIndex = existing.indexWhere((task) => task['id'] == updatedTask.id);

      if (taskIndex != -1) {
        // Update the task at the found index
        existing[taskIndex] = updatedTask.toMap();
        await _store.record(date).put(db, existing);
      } else {
        throw Exception("Task with ID $updatedTask.id not found for the date $date");
      }
    } else {
      throw Exception("No tasks found for the date $date");
    }
  }

  // Fetch All Pending Tasks
  Future<Map<DateTime, List<TaskModel>>> fetchAllPendingTasks() async {
    final finder = Finder(
      filter: Filter.custom((record) {
        try {
          final recordValue = record.value as List;
          return recordValue.any((task) => task['status'] == 'pending');
        } catch (e) {
          return false;
        }
      }),
    );

    final records = await _store.find(db, finder: finder);
    if (records.isEmpty) return {};

    // Serialize records to pass to the isolate
    final serializedRecords = records
        .map((record) => {
              'key': record.key,
              'value': List<Map<String, dynamic>>.from(record.value),
            })
        .toList();

    // Use compute to handle grouping in an isolate
    final groupedTasks = await compute(_groupPendingTasks, serializedRecords);

    return groupedTasks;
  }

  // Isolate Function: Group and filter tasks
  Map<DateTime, List<TaskModel>> _groupPendingTasks(List<Map<String, dynamic>> records) {
    final pendingTasks = <MapEntry<DateTime, TaskModel>>[];

    for (Map<String, dynamic> record in records) {
      final key = record['key'] as String;
      final tasks = List<Map<String, dynamic>>.from(record['value']);
      for (Map<String, dynamic> taskMap in tasks) {
        if (taskMap['status'] == 'pending') {
          pendingTasks.add(MapEntry(DateFormat('dd/MM/yyyy').parse(key), TaskModel.fromMap(taskMap)));
        }
      }
    }

    // Group tasks by their keys
    final grouped = groupBy(pendingTasks, (entry) => entry.key).map<DateTime, List<TaskModel>>((key, value) {
      return MapEntry(key, value.map((entry) => entry.value).toList());
    });
    return grouped;
  }

  // Fetch All Tasks
  Future<Map<String, List<TaskModel>>> fetchAllTasks() async {
    final allData = await _store.find(db);
    return {for (var record in allData) record.key: List<TaskModel>.from(record.value.map((task) => TaskModel.fromMap(task)))};
  }

  // Delete Tasks for a Date
  Future<void> deleteTasks(String date) async {
    await _store.record(date).delete(db);
  }
}
