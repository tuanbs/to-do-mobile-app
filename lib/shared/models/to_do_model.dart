class ToDo {
  static final String idColumn = 'Id';
  static final String createdDateColumn = 'CreatedDate';
  static final String descriptionColumn = 'Description';
  static final String guidColumn = 'Guid';
  static final String isDeletedColumn = 'IsDeleted';
  static final String isDoneColumn = 'IsDone';
  static final String updatedDateColumn = 'UpdatedDate';

  int id;
  String createdDate;
  String description;
  String guid;
  bool isDeleted;
  bool isDone;
  String updatedDate;

  ToDo(
      {this.id,
      this.createdDate,
      this.description,
      this.guid,
      this.isDeleted,
      this.isDone,
      this.updatedDate});

  ToDo.fromJson(Map<String, dynamic> json) {
    id = json[idColumn];
    createdDate = json[createdDateColumn];
    description = json[descriptionColumn];
    guid = json[guidColumn];
    isDeleted = json[isDeletedColumn] == 1;
    isDone = json[isDoneColumn] == 1;
    updatedDate = json[updatedDateColumn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
    if (id != null) {
      data[idColumn] = id;
    }
    
    data[createdDateColumn] = createdDate;
    data[descriptionColumn] = description;
    data[guidColumn] = guid;
    data[isDeletedColumn] = isDeleted == true ? 1 : 0;
    data[isDoneColumn] = isDone == true ? 1 : 0;
    data[updatedDateColumn] = updatedDate;
    return data;
  }
}