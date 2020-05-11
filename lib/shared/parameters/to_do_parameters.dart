import 'package:to_do_mobile_app/shared/models/to_do_model.dart';

class ToDoParameters {
  final int id;
  final String guid;

  ToDoParameters({this.id, this.guid});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ToDo.idColumn] = this.id;
    data[ToDo.guidColumn] = this.guid;
    return data;
  }
}