import 'package:flutter/material.dart';
import 'package:valdez_justinmerck/backend/loginScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:valdez_justinmerck/sqlDatabase/databaseHelper.dart';

    class Signupscreen extends StatelessWidget{
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SignupScreenHome(),
        );
        }
     }

   class SignupScreenHome extends StatefulWidget{
  @override
  State<SignupScreenHome> createState() => _SignupScreenHomeState();
}

class _SignupScreenHomeState extends State<SignupScreenHome> {
      var hidePassword1 = true;
      var hidePassword2 = true;

      //Create variables for Controllers
      var fullNameController = TextEditingController();
      var usernameController = TextEditingController();
      var password1Controller = TextEditingController();
      var password2Controller = TextEditingController();


      void displayInputs(){
        var fullname = fullNameController.text;
        var username = usernameController.text;
        var password1 = password1Controller.text;
        var password2 = password2Controller.text;

        print("The full name is $fullname");
        print("The username is $username");
        print("The Password is $password1");
        print("The Password 2 is $password2");
      }

      void inputValidations() async{
        if(fullNameController.text.isEmpty){
          AwesomeDialog(
            width: 300.0,
            context: context,
            title: 'Error',
            desc: 'Full name is required',
            dialogType: DialogType.error,
            btnOkOnPress: (){}
          ).show();
        }
        else if(usernameController.text.isEmpty){
          AwesomeDialog(
              width: 300.0,
              context: context,
              title: 'Error',
              desc: 'User name is required',
              dialogType: DialogType.error,
              btnOkOnPress: (){}
          ).show();
      }
        else if(password1Controller.text.isEmpty) {
          AwesomeDialog(
              width: 300.0,
              context: context,
              title: 'Error',
              desc: 'Password is required',
              dialogType: DialogType.error,
              btnOkOnPress: () {}
          ).show();
        }
        else if(password2Controller.text.isEmpty) {
          AwesomeDialog(
              width: 300.0,
              context: context,
              title: 'Error',
              desc: 'Confirm password is required',
              dialogType: DialogType.error,
              btnOkOnPress: () {}
          ).show();
        }
        else if(password1Controller.text != password2Controller.text){
          AwesomeDialog(
              width: 300.0,
              context: context,
              title: 'Error',
              desc: 'Password does not match',
              dialogType: DialogType.error,
              btnOkOnPress: () {}
          ).show();
        }

        else {
          final result = await DatabaseHelper().insertStudent(fullNameController.text, usernameController.text, password1Controller.text);
          if (result > 0){
            AwesomeDialog(
              width: 300.0,
              context: context,
              title: 'Success',
              desc: 'User successfully registered!',
              dialogType: DialogType.success,
              btnOkOnPress: (){}
            ).show();
          }
          else {
            AwesomeDialog(
                width: 300.0,
                context: context,
                title: 'Error',
                desc: 'There is an error adding user.',
                dialogType: DialogType.error,
                btnOkOnPress: () {}
            ).show();
          }
        }
      }


      void showHidePassword1(){
        if(hidePassword1 == true){
          setState(() {
            hidePassword1 = false;
          });

        }
        else{
          setState(() {
            hidePassword1 = true;
          });

        }
      }
      void showHidePassword2(){
        if(hidePassword2 == true){
          setState(() {
            hidePassword2 = false;
          });

        }
        else{
          setState(() {
            hidePassword2 = true;
          });

        }
      }


     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           centerTitle: true,
         ),
         body: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [

             Center(
               child: Text(
                 'Registration',
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
                   controller: fullNameController,
                   decoration: InputDecoration(
                     prefixIcon: Icon(Icons.supervised_user_circle),
                     labelText: 'Fullname',
                     border: OutlineInputBorder(),
                   ),
                 ),
               ),
             ),

             SizedBox(
               width: MediaQuery.of(context).size.width / 2,
               child: Padding(
                 padding: EdgeInsets.all(8.0),
                 child: TextField(
                   controller: usernameController,
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
                   controller: password1Controller,
                   obscureText: hidePassword1,
                   decoration: InputDecoration(
                     prefixIcon: Icon(Icons.password),
                     suffixIcon: IconButton(
                         onPressed: (){
                           showHidePassword1();
                         },
                         icon: Icon(Icons.remove_red_eye)
                     ),
                     labelText: 'Password',
                     border: OutlineInputBorder(),
                   ),
                 ),
               ),
             ),

             SizedBox(
               width: MediaQuery.of(context).size.width / 2,
               child: Padding(
                 padding: EdgeInsets.all(8.0),
                 child: TextField(
                   controller: password2Controller,
                   obscureText: hidePassword2,
                   decoration: InputDecoration(
                     prefixIcon: Icon(Icons.password),
                     suffixIcon: IconButton(
                         onPressed: (){
                           showHidePassword2();
                         },
                         icon: Icon(Icons.remove_red_eye)),
                     labelText: 'Confirm Password',
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
                   onPressed: () {
                     displayInputs();
                     inputValidations();
                   },
                   child: Text(
                     'Signup',
                     style: TextStyle(color: Colors.white),
                   ),
                 ),
               ),
             ),

             // Signup Row
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text('Registered?'),
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (context) => LoginScreen(),
                       ),
                     );
                   },
                   child: Text('Login'),
                 ),
               ],
             ),
           ],
         ),
       );
     }
}