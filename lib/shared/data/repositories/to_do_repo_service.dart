import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:to_do_mobile_app/app_constants.dart';

import 'package:to_do_mobile_app/shared/models/to_do_model.dart';
import 'package:to_do_mobile_app/shared/parameters/to_do_resource_parameters.dart';
import 'package:to_do_mobile_app/shared/services/app_db_context_service.dart';
import 'package:to_do_mobile_app/app_injections.dart';
import 'package:uuid/uuid.dart';

class ToDoRepoService {
  var _toDosBehaviorSubject = rxdart.BehaviorSubject<List<ToDo>>();

  Stream<List<ToDo>> get toDosObservable => _toDosBehaviorSubject.asBroadcastStream();

  AppDbContextService _appDbContextService;

  ToDoRepoService() {
    _appDbContextService = _appDbContextService ?? getIt<AppDbContextService>();
  }

  Future getListAsync(ToDoResourceParameters toDoResourceParameters) async {
    dynamic error;

    try {
      // Get data from local Sqlite Db. In the web app (like Angular or React), we get data by using `http`.
      var readOnlyList = await _appDbContextService.database?.query(
        AppConstants.tableTodoName, 
        columns: [ToDo.idColumn, ToDo.descriptionColumn, ToDo.guidColumn, ToDo.isDoneColumn, ToDo.updatedDateColumn, ToDo.isDeletedColumn], 
        where: '${ToDo.isDeletedColumn} = ?', whereArgs: [0],
        orderBy: '${ToDo.updatedDateColumn} DESC'
      );
      List<ToDo> list = readOnlyList?.map((item) => ToDo.fromJson(item))?.toList();
      _appDbContextService.toDos = List<ToDo>.from(list); // Create a new map to modify it in memory.
      // Notify to all listeners.
      _toDosBehaviorSubject.add(_appDbContextService.toDos);
      return Future.value();
    } catch (e) {
      error = e;
      debugPrint('ToDoRepoService getListAsync failed. error is: $error');
    }
    return Future.error(error);
  }

  Future<ToDo> addAsyncGet() async {
    dynamic error;

    try {
      // Get the empty to-do model. In the web app, we get it from the server API.
      return Future.value(new ToDo(createdDate: DateTime.now().toUtc().toString(), guid: Uuid().v1(), updatedDate: DateTime.now().toUtc().toString()));
    } catch (e) {
      error = e;
      debugPrint('ToDoRepoService addAsyncGet failed. error is: $error');
    }
    return Future.error(error);
  }

  Future<ToDo> addAsyncPost(ToDo paramObj) async {
    dynamic error;
    var db = _appDbContextService.database;

    try {
      List<dynamic> results;
      await db?.transaction((txn) async {
        var batch = txn.batch();
        batch.insert(
          AppConstants.tableTodoName,
          paramObj.toJson(),
        );
        results = await batch.commit();
        // debugPrint('results is: ${json.encode(results)}');
      });
      if (results != null) {
        paramObj.id = results[0];
        var list = List<ToDo>.from(_appDbContextService.toDos);
        list.insert(0, paramObj);
        _appDbContextService.toDos = list;
        _toDosBehaviorSubject.add(_appDbContextService.toDos);
        return Future.value(paramObj);
      }
    } catch (e) {
      error = e;
      print('ToDoRepoService addAsyncPost failed. error is: $error');
    }
    return Future.error(error);
  }
}