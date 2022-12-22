import 'package:flutter/material.dart';
import 'package:sqlite_assignment_bagac/model/todo_model.dart';
import 'package:sqlite_assignment_bagac/repository/database_repository.dart';
import 'package:sqlite_assignment_bagac/screen/update_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database_Repository? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = Database_Repository();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        centerTitle: true,
        elevation: 1,
        leading: const Icon(Icons.code),
      ),

      body: Column(
        children: [
          Expanded(child: FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<TodoModel>> snapshot){
              if(!snapshot.hasData || snapshot.data == null){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapshot.data!.length == 0){
                return const Center(
                  child: Text('No list yet',
                    style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  ),
                );
              }

              else{
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index){
                    int todoId = snapshot.data![index].id!.toInt();
                    String todoTitle = snapshot.data![index].title.toString();
                    String todoDescription = snapshot.data![index].description.toString();
                    String todoDateAndTime = snapshot.data![index].dateAndTime.toString();
                    return Dismissible(
                        key: ValueKey<int>(todoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.cancel, color: Colors.white,),
                        ),

                      onDismissed: (DismissDirection direction){
                          setState(() {
                            dbHelper!.delete(todoId);
                            dataList = dbHelper!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color(0xFF00b2ca),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      todoTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        fontFamily: "Times New Roman",
                                      ),
                                    ),

                                    InkWell(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder:
                                            (context) => AddUpdateTask(
                                              todoId: todoId,
                                              todoTitle: todoTitle,
                                              todoDescription: todoDescription,
                                              todoDateAndTime: todoDateAndTime,
                                              update: true,
                                            ))
                                        );
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              subtitle: Text(todoDescription,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14
                              ),
                              ),
                            ),

                            const Divider(
                              color: Colors.black,
                              thickness: 0.8,
                            ),

                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Posted: ${todoDateAndTime}",
                                  style: const TextStyle(
                                    fontSize: 10,
                                  )
                                  ),



                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                    }
                );
              }
            },
          ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            Icons.add,
        ),
        backgroundColor: Color(0xFF00b2ca),
        onPressed: (){
          Navigator.push(
              context, 
              MaterialPageRoute(
                  builder: (context) => AddUpdateTask(),
              )
          );
        },
      ),
    );
  }
}

