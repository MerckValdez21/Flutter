import 'package:flutter/material.dart';
import 'package:valdez_justinmerck/backend/signupScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
