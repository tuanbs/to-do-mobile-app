import 'package:to_do_mobile_app/shared/models/to_do_model.dart';

class ToDoParameters {
  final int id;

  ToDoParameters({this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ToDo.idColumn] = this.id;
    return data;
  }
}