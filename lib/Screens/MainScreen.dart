import 'package:Hooked/Screens/CreatePostScreen/CreatePostScreen.dart';
import 'package:Hooked/Screens/HomeScreen/HomeScreen.dart';
import 'package:Hooked/Screens/BasicUI/LoadingScreen.dart';
import 'package:Hooked/Screens/Login/LoginScreen.dart';
import 'package:Hooked/Screens/PostScreen/PostScreen.dart';
import 'package:Hooked/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return MainWidget();
          }

          /// other way there is no user logged.
          return LoginScreen();
        });
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedScreen = 0;

  HookedUser currentHookedUser;

  String userName;

  static const List<Widget> screens = [
    HomeScreen(),
    PostScreen()
  ];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    HookedUser user =
        await HookedUser.getUserbyId(FirebaseAuth.instance.currentUser.uid);

    setState(() {
      this.currentHookedUser = user;
    });
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  _showNewPostDialog(BuildContext context){

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePostScreen(),fullscreenDialog: true ));

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Stack(children: [
            screens[_selectedScreen],
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(child: Icon(Icons.add),onPressed: () => _showNewPostDialog(context),),
              ),
            )
            ]
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.article), label: "Post"),
            ],
            currentIndex: _selectedScreen,
            onTap: _onItemTapped,
          )),
    );
  }
}
