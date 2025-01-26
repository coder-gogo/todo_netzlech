import 'dart:io';
import 'package:injectable/injectable.dart' as i;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

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

  // Insert or Update Data
  Future<void> insertSession(
    String date,
    Map<String, dynamic> sessionData,
  ) async {
    // Fetch existing data for the date
    final existingData = await _store.record(date).get(db);

    // If data doesn't exist for the date, create new entry
    if (existingData == null) {
      await _store.record(date).put(db, [sessionData]);
    } else {
      // If data exists, update the list with the new session
      List existing = List.from(existingData);
      existing.add(sessionData);
      await _store.record(date).put(db, existing);
    }
  }

  // Fetch Sessions for a Date
  Future<List> fetchSessions(String date) async {
    final data = await _store.record(date).get(db);
    return data ?? [];
  }

  // Update Sessions for a Date
  Future<void> updateSessions(String date, List value) async {
    await _store.record(date).update(db, value);
  }

  // Fetch All Sessions
  Future<Map<String, List<Map<String, dynamic>>>> fetchAllSessions() async {
    final allData = await _store.find(db);
    return {for (var record in allData) record.key: (record.value).cast<Map<String, dynamic>>()};
  }

  // Fetch All Sessions
  Future<MapEntry<String, List<Map<String, dynamic>>>?> fetchTodaySession() async {
    final today = DateTime.now();
    final date = '${today.day}/${today.month}/${today.year}'; // e.g., "7/1/2025"

    // Fetch the record with the key equal to the date
    final record = await _store.record(date).get(db);

    // If no record exists for the date, return an empty map
    if (record == null || record.isEmpty) return null;

    // Cast the record value to the required type and return it
    return MapEntry(date, List<Map<String, dynamic>>.from(record));
  }

  Future<List<MapEntry<String, List<Map<String, dynamic>>>>> fetchDateWiseSession(DateTime start, DateTime end) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        try {
          if (record.key == null || record.key.toString().isEmpty) return false;
          final recordDate = parseDate(record.key.toString());
          if (recordDate == null) return false;
          return recordDate.isAfter(start.subtract(const Duration(days: 1))) && recordDate.isBefore(end.add(const Duration(days: 1)));
        } catch (e) {
          return false;
        }
      }),
    );

    // Find records matching the date range
    final records = await _store.find(db, finder: finder);

    if (records.isEmpty) return [];

    // Convert records to a serializable format
    final serializableRecords = records.map((record) {
      return {
        'key': record.key,
        'value': record.value,
      };
    }).toList();

    // Process records using compute for multithreading
    final processedRecords = await compute(_processRecords, serializableRecords);

    return processedRecords;
  }

  List<MapEntry<String, List<Map<String, dynamic>>>> _processRecords(List<Map<String, dynamic>> records) {
    return records.map((record) {
      return MapEntry(
        record['key'].toString(),
        List<Map<String, dynamic>>.from(record['value']),
      );
    }).toList();
  }

  // Delete Sessions for a Date
  Future<void> deleteSessions(String date) async {
    await _store.record(date).delete(db);
  }
}
