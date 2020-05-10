import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_mobile_app/app_constants.dart';
import 'package:to_do_mobile_app/app_injections.dart';
import 'package:to_do_mobile_app/shared/data/repositories/to_do_repo_service.dart';

import 'package:to_do_mobile_app/shared/models/to_do_model.dart';
import 'package:to_do_mobile_app/shared/parameters/to_do_parameters.dart';

class Home extends StatefulWidget {
  static const String title = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<List<ToDo>> _toDosObservableSubscriber;
  List<ToDo> _toDos;

  /* DI Services vars. */
  ToDoRepoService _toDoRepoService;

  _HomeState() {
    /* DI Services. */
    _toDoRepoService = _toDoRepoService ?? getIt<ToDoRepoService>();
  }

  //#region Lifecycle.
  @override
  void initState() {
    super.initState();
    _toDosObservableSubscriber = _toDoRepoService.toDosObservable.listen((data) {
      // debugPrint('data is: ${json.encode(data)}');
      _toDos = data;
      if (_toDos != null) {
        setState(() {});
      }
    });

    _getListAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Home.title),
        actions: [
          // FloatingActionButton(
          //   child: Icon(Icons.more_horiz),
          //   mini: true,
          //   backgroundColor: Colors.lightBlue,
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _toDos == null ? 0 : _toDos.length,
          itemBuilder: (BuildContext context, int index) {
            ToDo item = _toDos[index];
            return Dismissible(
              key: Key(item?.id.toString()),
              child: ListTile(
                leading: IconButton(
                  icon: Icon((item?.isDone == true ? Icons.radio_button_checked : Icons.radio_button_unchecked), color: Colors.blueAccent,),
                  onPressed: () {},
                ),
                title: Text(
                  item?.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                subtitle: Text(
                  (item.updatedDate ?? '') == '' ? '' : '${DateFormat('EEE, y/M/d').format(DateTime.parse(item.updatedDate))}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onTap: () {},
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0), // Use padding because the bottom bar covers it.
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _navigateTo(null, AppConstants.addToDoPath);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _toDosObservableSubscriber.cancel();
  }
  //#end-region.

  //#region Helpers.
  Future _getListAsync() async {
    bool isOk = false;
    
    try {
      // await _dialogService.showSpinner();

      await _toDoRepoService.getListAsync(null);
      isOk = true;
    } catch (e) {
      debugPrint('_getListAsync failed.');
    } finally {
      // await _dialogService.hideSpinner();

      if (isOk) {}
    }
  }

  void _navigateTo(ToDo toDo, String componentPath) {
    var queryParamsObj = ToDoParameters(id: toDo?.id);
    Navigator.pushNamed(context, componentPath, arguments: queryParamsObj);
  }
  //#end-region.
}