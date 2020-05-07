class ToDoResourceParameters {
  final String searchQuery;

  ToDoResourceParameters({this.searchQuery});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchQuery'] = this.searchQuery;
    return data;
  }
}