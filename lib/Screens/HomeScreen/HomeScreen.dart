import 'dart:io';

import 'package:Hooked/Screens/PostScreen/Components/PostCard.dart';
import 'package:Hooked/models/post.dart';
import 'package:Hooked/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ProfilePicture.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HookedUser user;
  String username = "Loading";
  Image pic;
  List<Post> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
    _getPosts();
  }

  _getUser() async {
    this.user =
        await HookedUser.getUserbyId(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      if (user.profilePicUrl != null) {
        pic = Image.network(
          user.profilePicUrl,
          fit: BoxFit.fill,
        );
      }
      username = user.firstName + " " + user.lastName;
    });
  }

  _selectPhoto() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    var imageFile = File(image.path);
    await HookedUser.updateProfilePicToUser(user, imageFile);
    _getUser();
  }

  void _getPosts() async {
    var loadedPost =
        await Post.getPostsbyUserid(FirebaseAuth.instance.currentUser.uid);
    print(loadedPost);

    setState(() {
      this.posts = loadedPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => FirebaseAuth.instance.signOut())
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: homeHeader(),
                ),
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Container(child: PostCard(post: posts[index]));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container homeHeader() {
    return Container(
      height: 100,
      child: Row(
        children: [
          GestureDetector(
              onTap: () => _selectPhoto(),
              child: ProfilePicture(
                pic: pic,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  username,
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
