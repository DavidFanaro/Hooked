import 'package:Hooked/Screens/PostScreen/Components/PostCard.dart';
import 'package:Hooked/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _getPost();
  }

  void _getPost() async {
    var data = await Post.getAllPosts();
    setState(() {
      _posts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Post"),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => FirebaseAuth.instance.signOut())
          ],
        ),
        body: Container(
          child: RefreshIndicator(
            onRefresh: () async => _getPost(), 
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(thickness: 4,),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: _posts[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
