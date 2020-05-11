import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_mobile_app/app_injections.dart';
import 'package:to_do_mobile_app/shared/data/repositories/to_do_repo_service.dart';
import 'package:to_do_mobile_app/shared/models/to_do_model.dart';
import 'package:to_do_mobile_app/shared/parameters/to_do_parameters.dart';

class EditToDo extends StatefulWidget {
  static const String title = 'EditToDo';
  final ToDoParameters toDoParameters;

  EditToDo({@required this.toDoParameters}); // Capture the params sent from `Home` component.

  @override
  _EditToDoState createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
  final _formKey = GlobalKey<FormState>();
  ToDo _updatingToDo;

  /* DI Services vars. */
  ToDoRepoService _toDoRepoService;

  _EditToDoState() {
    /* DI Services. */
    _toDoRepoService = _toDoRepoService ?? getIt<ToDoRepoService>();
  }

  //#region Lifecycle.
  @override
  void initState() {
    super.initState();    

    _updateGet(new ToDo(guid: widget.toDoParameters.guid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EditToDo.title),
        actions: <Widget>[
          FloatingActionButton(
            child: Text('Save'),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.yellowAccent,
            elevation: 0,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              _updatePost();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: TextEditingController(text: _updatingToDo?.description ?? '',),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Edit to-do",
                      hintText: "Edit to-do.",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    // autofocus: true,
                    validator: (value) => value.isNotEmpty ? null : 'Description can\'t be empty',
                    onSaved: (value) => _updatingToDo.description = value?.trim(),
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
  Future _updateGet(ToDo updatingToDo) async {
    bool isOk = false; ToDo response;
    
    try {
      // await _dialogService.showSpinner();
      
      ToDo res = await _toDoRepoService.updateGet(updatingToDo);
      if (res != null) {
        response = res;
        isOk = true;
      }
    } catch (e) {
      debugPrint('_updateGet failed.');
    } finally {
      print('finally called.');
      // await _dialogService.hideSpinner();

      if (isOk) {
        setState(() {
          _updatingToDo = response;
          debugPrint('_updatingToDo is ${json.encode(_updatingToDo)}');
        });
      }
    }
  }

  Future _updatePost() async {
    if (!_validateAndSaveForm()) { return; }

    bool isOk = false;
    try {
      // await _dialogService.showSpinner();
      ToDo copiedUpdatingToDo = ToDo.fromJson(_updatingToDo.toJson());
      debugPrint('copiedUpdatingToDo is: ${json.encode(copiedUpdatingToDo)}');

      await _toDoRepoService.updatePost(copiedUpdatingToDo);
      isOk = true;
    } catch (e) {
      debugPrint('_updatePost failed');
    } finally {
      debugPrint('finally called.');
      // await _dialogService.hideSpinner();
      
      if (isOk) {
        Navigator.pop(context);
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