import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_mobile_app/app_injections.dart';
import 'package:to_do_mobile_app/shared/data/repositories/to_do_repo_service.dart';
import 'package:to_do_mobile_app/shared/models/to_do_model.dart';

class AddToDo extends StatefulWidget {
  static const String title = 'AddToDo';

  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final _formKey = GlobalKey<FormState>();
  ToDo _newToDo;

  /* DI Services vars. */
  ToDoRepoService _toDoRepoService;

  _AddToDoState() {
    /* DI Services. */
    _toDoRepoService = _toDoRepoService ?? getIt<ToDoRepoService>();
  }

  //#region Lifecycle.
  @override
  void initState() {
    super.initState();    

    _addAsyncGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddToDo.title),
        actions: <Widget>[
          FloatingActionButton(
            child: Text('Done'),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.yellowAccent,
            elevation: 0, // This is to hide the shadow.
            onPressed: () async {
              FocusScope.of(context).unfocus();
              _addAsyncPost();
            },
          ),
        ],
      ),
      body: GestureDetector( // Catch event when tapping outside.
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide/ dismiss keyboard.
        },
        child: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Add to-do",
                      hintText: "Add new to-do.",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // To use auto wrap.
                    // autofocus: true,
                    validator: (value) => value.isNotEmpty ? null : 'Description can\'t be empty',
                    onSaved: (value) => _newToDo.description = value?.trim(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  //#end-region.

  //#region Helpers.
  Future _addAsyncGet() async {
    bool isOk = false; ToDo response;
    
    try {
      // await _dialogService.showSpinner();

      ToDo res = await _toDoRepoService.addAsyncGet();
      if (res != null) {
        response = res;
        isOk = true;
      }
    } catch (e) {
      debugPrint('_addAsyncGet failed.');
    } finally {
      print('finally called.');
      // await _dialogService.hideSpinner();

      if (isOk) {
        setState(() {
          _newToDo = response;
          // debugPrint('_newToDo is ${json.encode(_newToDo)}');
        });
      }
    }
  }

  Future _addAsyncPost() async {
    if (!_validateAndSaveForm()) { return; }

    bool isOk = false;
    try {
      // await _dialogService.showSpinner();
      ToDo copiedNewToDo = ToDo.fromJson(_newToDo.toJson());
      // debugPrint('copiedNewToDo is: ${json.encode(copiedNewToDo)}');

      ToDo res = await _toDoRepoService.addAsyncPost(copiedNewToDo);
      debugPrint('res.id is: ${res.id}');
      isOk = true;
    } catch (e) {
      debugPrint('_addAsyncPost failed');
    } finally {
      print('finally called.');
      // await _dialogService.hideSpinner();
      
      if (isOk) {
        Navigator.pop(context); // Get back to previous page.
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  //#end-region.
}