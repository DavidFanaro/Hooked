
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

    String _userId;
    String _textContent;
    String _imageUrl;
    String _fish;
    DateTime _createdDate;

    Post(this._userId, this._textContent, this._imageUrl, this._fish, this._createdDate);

    String get userId {
      return this._userId;
    }
    String get textContent {
      return this._textContent;
    }
    String get imageUrl {
      return this._imageUrl;
    }
    String get fish {
      return this._fish;
    }
    DateTime get createdDate {
      return this._createdDate;
    }

    

    static void createPost(Post post) async {
      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection("/posts").add({
        "userId" : post._userId,
        "textContent" : post._textContent,
        "imageUrl" : post._imageUrl,
        "fish" : post._fish,
        "createdDate" : post._createdDate.toUtc().toString()
      });
    }

    static Future<List<Post>> getPostsbyUserid(String id) async {
      FirebaseFirestore db = FirebaseFirestore.instance;

      List<Post> userPosts = [];

      var postQuery = await db.collection("/posts").where("userId", isEqualTo: id).get();
      var data = postQuery.docs;
      for (var post in data) {
        var data = post.data();
        var newPost = Post(data["userId"], data["textContent"], data["imageUrl"], data["fish"], DateTime.parse(data["createdDate"]));
        userPosts.add(newPost);
      }

      return userPosts.reversed.toList();
    }

    static Future<List<Post>> getAllPosts() async {
      FirebaseFirestore db = FirebaseFirestore.instance;

      List<Post> userPosts = [];

      var postQuery = await db.collection("/posts").get();
      var data = postQuery.docs;
      for (var post in data) {
        var data = post.data();
        var newPost = Post(data["userId"], data["textContent"], data["imageUrl"], data["fish"], DateTime.parse(data["createdDate"]));
        userPosts.add(newPost);
      }
      return userPosts.reversed.toList();
    }

  
}