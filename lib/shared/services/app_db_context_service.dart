import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:to_do_mobile_app/app_constants.dart';
import 'package:to_do_mobile_app/shared/models/to_do_model.dart';

class AppDbContextService {
  String _databasesPath;
  Database database;

  /* DataStore stuffs for ToDos. */
  List<ToDo> _toDos;

  List<ToDo> get toDos { return _toDos; }
  set toDos(List<ToDo> value) { _toDos = value ?? null; }

  AppDbContextService() {
    // RxDart stuffs.
    toDos = [];
  }

  //#region Helpers.
  //#end-region.

  // Future<void> doExecuteQuery(String query, List<dynamic> dataArray, successCb, errorCb) async {
  //   if (_db == null) { await initDb(); } // Fixing issue of Null db while using Live Reload feature.

  //   await _db.transaction((tx) async {
  //     var res = await tx.execute(query, dataArray);
  //   });

  //   // db.transaction(
  //   //     function (tx) {
  //   //         tx.executeSql(query, dataArray, 
  //   //             function (tx, res) { successCb(tx, res); }, 
  //   //             function (tx, err) { errorCb(tx, err); }
  //   //         );
  //   //     },
  //   //     function (err) { console.error('doExecuteQuery transaction error: ' + JSON.stringify(err)); },
  //   //     function () { console.info('doExecuteQuery transaction Ok.'); }
  //   // );
  // }

  Future<void> dropDb() async {
    try {
      _databasesPath = await getDatabasesPath();
      _databasesPath = join(_databasesPath, AppConstants.databaseName);
      if (await databaseExists(_databasesPath)) {
        await deleteDatabase(_databasesPath);
        debugPrint('Drop existing DB successfully');
      }
    } catch (e) {
      debugPrint('Exception in AppDbContextService.dropDb(). e is: $e');
    }
  }

  Future<void> initDb() async {
    _databasesPath = await getDatabasesPath();
    _databasesPath = join(_databasesPath, AppConstants.databaseName);

    // Check if the database exists.
    bool exists = await databaseExists(_databasesPath);

    if (!exists) {
      // Should happen only the first time when you launch your app.
      debugPrint("Database not exist. Creating new copy from assets.");

      // Make sure the parent directory exists.
      try {
        await Directory(dirname(_databasesPath)).create(recursive: true);

        // Copy from asset.
        ByteData data = await rootBundle.load(join("assets/database", AppConstants.databaseName));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        
        // Write and flush the bytes written.
        await File(_databasesPath).writeAsBytes(bytes, flush: true);
      } catch (e) {
        debugPrint('Exception in AppDbContextService.initDb(). e is: $e');
      }
    } else {
      debugPrint("Database already exists.");
    }
    // open the database.
    database = await openDatabase(_databasesPath);
    debugPrint('initDb successfully. _databasesPath is: $_databasesPath');
  }
}