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
  int isDeleted; // NOTE: bool is not supported by Sqlite.
  int isDone;
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
    isDeleted = json[isDeletedColumn] ?? 0;
    isDone = json[isDoneColumn] ?? 0;
    updatedDate = json[updatedDateColumn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[idColumn] = this.id;
    data[createdDateColumn] = this.createdDate;
    data[descriptionColumn] = this.description;
    data[guidColumn] = this.guid;
    data[isDeletedColumn] = this.isDeleted;
    data[isDoneColumn] = this.isDone;
    data[updatedDateColumn] = this.updatedDate;
    return data;
  }
}