import 'dart:io';

import 'package:Hooked/Screens/BasicUI/LoadingScreen.dart';
import 'package:Hooked/Screens/Login/LoginScreen.dart';
import 'package:Hooked/Screens/MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

void main() {
  runApp(App());
}

firebaseConfig(){
  FirebaseFirestore.instance.enablePersistence();
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return Text("Error");
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return LoadingScreen();
    }

    return MyApp();
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            // backgroundColor: Colors.grey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.grey
            ),
        home: MainScreen());
    
  }
}
