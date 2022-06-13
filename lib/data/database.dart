import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  final int _version = 1;

  factory DatabaseHelper() => _instance;

  Database _db;

  DatabaseHelper.internal();

  final taskStore = stringMapStoreFactory.store('tasks');

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  _initDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'task.db');
    final database = await databaseFactoryIo.openDatabase(dbPath, version: _version);
    return database;
  }

  Future<bool> addTask(String id, value) async {
    var client = await db;
    try {
      await taskStore.record(id).put(client, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getTasks() async {
    var client = await db;
    try {
      final result = await taskStore.find(client);
      return result??[];
    } catch (e) {
      return [];
    }
  }

  Future<bool> clear() async {
    var client = await db;
    try {
      await taskStore.delete(client);
      return true;
    } catch (e) {
      return false;
    }
  }
}
