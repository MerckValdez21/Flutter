import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';

import '../sqlDatabase/databaseHelper.dart';
import 'dashboard.dart';

class ListOfUsers extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListOfUsersHome(),
    );
  }
}

class ListOfUsersHome extends StatefulWidget{
  @override
  State<ListOfUsersHome> createState() => _ListOfUsersHomeState();
}

class _ListOfUsersHomeState extends State<ListOfUsersHome> {
  var students = [];

  void getAllStudents() async{
    final data = await DatabaseHelper().getAllStudents();
    setState(() {
      students = data;
    });
    print(students.toString());
  }
  @override
  void initState(){
    super.initState();
    getAllStudents();
  }
  //Create a BottomModalSheet for Editing
  void editUser(BuildContext context, int userId, String fullName, String username, String password){
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context){
          //Initialize Controllers for Editing
          var fullNameController = TextEditingController();
          var usernameController = TextEditingController();
          var passwordController = TextEditingController();
          //Initialize Values for TextField Controllers
          fullNameController.text = fullName;
          usernameController.text = username;
          passwordController.text = password;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(

                        )
                    ),
                    controller: fullNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    controller: usernameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    controller: passwordController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/1.1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.green),
                        ),
                        onPressed: () async{
                          final updateResult = await DatabaseHelper().updateStudent(userId, fullNameController.text, usernameController.text, passwordController.text);
                          if(updateResult > 0){
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: 'Success',
                                desc: 'User successfully Updated',
                                btnOkOnPress: (){
                                  getAllStudents();
                                  setState(() {

                                  });
                                }
                            ).show();
                          }
                          else{
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error',
                                desc: 'There is an error updating the user.',
                                btnOkOnPress: (){

                                }
                            ).show();

                          }
                        },
                        child: Text('Update User', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
              ],
            ),
          );
        }

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context)=>Dashboard()
                  )
              );
            },
            icon: Icon(Icons.arrow_back)
        ),
        automaticallyImplyLeading: false,
        title: Text("List of Users"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (BuildContext context, index){
                var userId = students[index]['id'];
                var fullName = students[index]['fullName'];
                var userName = students[index]['username'];
                var password = students[index]['password'];
                return ListTile(
                  leading: Icon(Icons.group),
                  title: Text("$fullName"),
                  subtitle: Text("$userName"),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width/4,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              //Call the editUser method Above
                              editUser(context, userId, fullName, userName, password);
                            },
                            icon: Icon(Icons.edit, color:  Colors.green,)
                        ),
                        IconButton(
                            onPressed: (){
                              AwesomeDialog(
                                  context: context,
                                  title: 'Warning',
                                  desc: 'Are you sure you want to delete this user?',
                                  dialogType: DialogType.warning,
                                  btnOkOnPress: () async{
                                    await DatabaseHelper().deleteStudent(userId);
                                    getAllStudents();
                                  },
                                  btnCancelOnPress: (){

                                  }
                              ).show();
                            },
                            icon: Icon(Icons.delete, color:  Colors.red,)
                        )
                      ],
                    ),
                  ),
                );

              }
          )
        ],
      ),
    );
  }
}