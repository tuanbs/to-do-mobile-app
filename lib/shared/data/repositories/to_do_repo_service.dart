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
        columns: [ToDo.idColumn, ToDo.createdDateColumn, ToDo.descriptionColumn, ToDo.guidColumn, ToDo.isDoneColumn, ToDo.updatedDateColumn, ToDo.isDeletedColumn], 
        where: '${ToDo.isDeletedColumn} = ?', whereArgs: [0],
        orderBy: '${ToDo.createdDateColumn} DESC'
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
      return Future.value(new ToDo(createdDate: DateTime.now().toUtc().toString(), guid: Uuid().v1(),));
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
      paramObj.updatedDate = DateTime.now().toUtc().toString(); // Need to be the current time before saving to Sqlite db.

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
        paramObj.id = results.first;
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

  Future<ToDo> updateGet(ToDo paramObj) async {
    ToDo updatingItem; dynamic error;

    try {
      // Get the to-do model by guid. In the web app, we get it from the server API.
      var readOnlyList = await _appDbContextService.database?.query(
        AppConstants.tableTodoName, 
        columns: [ToDo.descriptionColumn, ToDo.createdDateColumn, ToDo.guidColumn, ToDo.isDoneColumn, ToDo.updatedDateColumn, ToDo.isDeletedColumn], 
        where: '${ToDo.guidColumn} = ?', whereArgs: [paramObj?.guid],
      );
      updatingItem = ToDo.fromJson(readOnlyList?.first);

      if (updatingItem != null) {
        return Future.value(updatingItem);
      }
    } catch (e) {
      error = e;
      debugPrint('ToDoRepoService updateGet failed. error is: $error');
    }
    return Future.error(error);
  }

  Future updatePost(ToDo paramObj) async {
    dynamic error;
    var db = _appDbContextService.database;

    try {
      List<dynamic> results;
      paramObj.updatedDate = DateTime.now().toUtc().toString();

      await db?.transaction((txn) async {
        var batch = txn.batch();
        batch.update(
          AppConstants.tableTodoName,
          paramObj.toJson(),
          where: '${ToDo.guidColumn} = ?', whereArgs: [paramObj?.guid],
        );
        results = await batch.commit();
        // debugPrint('updatePost results is: ${json.encode(results)}');
      });
      if (results.first > 0) {
        ToDo updatedItem = await updateGet(paramObj);
        var updatingItemIndex = _appDbContextService.toDos.indexWhere((item) => item.guid == updatedItem.guid);
        if (updatingItemIndex != -1) {
          _appDbContextService.toDos[updatingItemIndex] = updatedItem;
          _toDosBehaviorSubject.add(_appDbContextService.toDos);
        }
        return Future.value();
      }
    } catch (e) {
      error = e;
      debugPrint('ToDoRepoService updatePost failed. error is: $error');
    }
    return Future.error(error);
  }

  Future deletePost(ToDo paramObj) async {
    dynamic error;
    var db = _appDbContextService.database;

    try {
      List<dynamic> results;
      await db?.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(
          AppConstants.tableTodoName,
          where: '${ToDo.guidColumn} = ?', whereArgs: [paramObj?.guid],
        );
        results = await batch.commit();
        // debugPrint('deletePost results is: ${json.encode(results)}');
      });
      if (results.first > 0) {
        var deletingItem = _appDbContextService.toDos.firstWhere((item) => item.guid == paramObj.guid, orElse: () => null);
        if (_appDbContextService.toDos.contains(deletingItem)) {
          _appDbContextService.toDos.remove(deletingItem);
          _toDosBehaviorSubject.add(_appDbContextService.toDos);
        }

        /// Reference only: delete based on index.
        // var deletingItemIndex = _appDbContextService.toDos.indexWhere((item) => item.guid == paramObj.guid);
        // if (deletingItemIndex != -1) {
        //   _appDbContextService.toDos.removeAt(deletingItemIndex);
        //   _toDosBehaviorSubject.add(_appDbContextService.toDos);
        // }
        return Future.value();
      }
    } catch (e) {
      error = e;
      debugPrint('ToDoRepoService deletePost failed. error is: $error');
    }
    return Future.error(error);    
  }

  Future toggleIsDone(ToDo paramObj) async {
    dynamic error;
    var db = _appDbContextService.database;

    try {
      var paramObjJson = paramObj.toJson();
      List<dynamic> results;
      await db?.transaction((txn) async {
        var batch = txn.batch();
        batch.update(
          AppConstants.tableTodoName,
          // We just need to update `IsDone` column.
          {ToDo.isDoneColumn: paramObjJson[ToDo.isDoneColumn]},
          where: '${ToDo.guidColumn} = ?', whereArgs: [paramObj?.guid],
        );
        results = await batch.commit();
        // debugPrint('updatePost results is: ${json.encode(results)}');
      });
      if (results.first > 0) {
        var updatingItemIndex = _appDbContextService.toDos.indexWhere((item) => item.guid == paramObj.guid);
        if (updatingItemIndex != -1) {
          _appDbContextService.toDos[updatingItemIndex] = ToDo.fromJson(paramObjJson);
          _toDosBehaviorSubject.add(_appDbContextService.toDos);
        }
        return Future.value();
      }
    } catch (e) {
      error = e;
      debugPrint('ToDoRepoService updatePost failed. error is: $error');
    }
    return Future.error(error);
  }
}