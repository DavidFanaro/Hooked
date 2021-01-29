import 'package:Hooked/Screens/Login/LoginScreen.dart';
import 'package:Hooked/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context){
        return StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot){
                       if (snapshot.hasData){
                           User user = snapshot.data; // this is your user instance
                           /// is because there is user already logged
                           return MainWidget();
                        }
                         /// other way there is no user logged.
                         return LoginScreen();
             }
          );
    }

  
}

class MainWidget extends StatelessWidget {

  HookedUser currentHookedUser;
  String userName;

  MainWidget() {
    getuser();
    userName = this.currentHookedUser.firstName + " " + this.currentHookedUser.lastName;
  }

  getuser () async {
    currentHookedUser = await HookedUser.getUserbyId(FirebaseAuth.instance.currentUser.uid);
  }

   

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hello World"),
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: () => FirebaseAuth.instance.signOut())
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("/users").where('id' , isEqualTo: FirebaseAuth.instance.currentUser.uid).get(),
                  builder: (context, snapshot) => 
                  Column(
            children: [

              

              Row(children: [
              
                Text("Welcome to Hooked $userName", style: TextStyle(fontSize: 30),),
                ],
              mainAxisAlignment: MainAxisAlignment.center,

              )

            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
      ),
    );
  }
}