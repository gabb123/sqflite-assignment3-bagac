class TodoModel {
  final int? id;
  final String? title;
  final String? description;
  final String? dateAndTime;

  TodoModel(
      {
        this.id,
        this.title,
        this.description,
        this.dateAndTime
      }
      );

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res ['title'],
        description = res ['description'],
        dateAndTime = res ['dateAndTime'];

        Map<String, Object?> toMap(){
    return {
      "id" : id,
      "title" : title,
      "description" : description,
      "dateAndTime" : dateAndTime,
    };
  }
}