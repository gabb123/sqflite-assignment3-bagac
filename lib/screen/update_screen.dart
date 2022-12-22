import 'package:flutter/material.dart';
import 'package:sqlite_assignment_bagac/model/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_assignment_bagac/repository/database_repository.dart';
import 'package:sqlite_assignment_bagac/screen/home_page.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDescription;
  String? todoDateAndTime;
  bool? update;

  AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDescription,
    this.todoDateAndTime,
    this.update,
    Key? key}) : super(key: key);

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  Database_Repository? dbHelper;
  late Future<List<TodoModel>> dataList;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState(){
    super.initState();
    dbHelper = Database_Repository();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();

  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descriptionController = TextEditingController(text: widget.todoDescription);
    String appTitle;
    if(widget.update == true){
      appTitle = "Update Task";
    }
    else{
      appTitle = "Add Task";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 75),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: titleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title Note',
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter your title";
                              }
                              return null;
                            },
                          ),
                      ),

                      const SizedBox(height: 20,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Type something in your mind";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
              ),

              SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue,
                      child: InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            if(widget.update == true){
                              dbHelper!.update(TodoModel(
                                id: widget.todoId,
                                title: titleController.text,
                                description: descriptionController.text,
                                dateAndTime: widget.todoDateAndTime,
                              )
                              );
                            }

                            else{
                              dbHelper!.insert(TodoModel(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  dateAndTime: DateFormat('yMd')
                                      .add_jm()
                                      .format(DateTime.now())
                                      .toString()
                              )
                              );
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()));
                            titleController.clear();
                            descriptionController.clear();
                            print("Data Added");
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 50,
                          width: 100,
                          decoration: const BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //   color: Color(0xFF42A5F5),
                            //     blurRadius: 5,
                            //     spreadRadius: 0.5
                            // )
                            // ]
                          ),
                          child: const Text("Post",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                          ),
                        ),
                      ),
                    ),

                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF00b2ca),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            titleController.clear();
                            descriptionController.clear();
                          }
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 50,
                          width: 100,
                          decoration: const BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //   color: Color(0xFF42A5F5),
                            //     blurRadius: 5,
                            //     spreadRadius: 0.5
                            // )
                            // ]
                          ),
                          child: const Text("Clear",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
