import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:valdez_justinmerck/backend/dashboard.dart';
import 'package:valdez_justinmerck/backend/signupScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:valdez_justinmerck/sqlDatabase/databaseHelper.dart';

// Primary Class
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenHome(),
    );
  }
}

// Secondary Class
class LoginScreenHome extends StatefulWidget {
  @override
  State<LoginScreenHome> createState() => _LoginScreenHomeState();
}

class _LoginScreenHomeState extends State<LoginScreenHome> {
  //Declare Variables here
  //Initialize Controllers for Username and Password
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  var hidePassword = true;

  // Show or Hide Password
  void showHidePassword() {
    if (hidePassword == true) {
      setState(() {
        hidePassword = false;
      });
    }
    else {
      setState(() {
        hidePassword = true;
      });
    }
  }
  void validateInputs() async{

    if(usernameController.text.isEmpty){
      AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Username is empty',
          btnOkOnPress: (){}
      ).show();
    }
    else if(passwordController.text.isEmpty){
      AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Password is empty',
          btnOkOnPress: (){}
      ).show();
    }
    else{
      //Execute the Login Algorithm
      final users = await DatabaseHelper().loginUser(usernameController.text, passwordController.text);
      if(users.isEmpty){
        AwesomeDialog(
            context: context,
            title: 'Invalid Username or Password',
            dialogType: DialogType.error,
            desc: 'User not found in the Database',
            btnOkOnPress: (){}
        ).show();
      }
      else{
        //Navigate to Dashboard
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Login Success',
            desc: 'User successfully validated',
            btnOkOnPress: (){}
        ).show();
        //Navigate to Dashboard
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context)=>Dashboard()
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Card(
          elevation: 30.0,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(
              child: Text(
                'Please Login to continue',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Username
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.supervised_user_circle),
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            // Password
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                        onPressed: (){
                          showHidePassword();
                        },
                        icon: Icon(Icons.remove_red_eye)),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            // Login Button
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 18,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            // Signup Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Account?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Signupscreen(),
                      ),
                    );
                  },
                  child: Text('Signup'),
                ),
              ],
            ),
          ],
        ),
    ),
      ),
    );
  }
}
