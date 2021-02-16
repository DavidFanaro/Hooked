
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HookedUser {

  String id, firstName, lastName, profilePicUrl;
  
  HookedUser(this.id, this.firstName,this.lastName, this.profilePicUrl);

  Map<String,dynamic> toJson(){
    return {
      "id" : id,
      "ProfilePic" : profilePicUrl,
      "FirstName" : firstName,
      "LastName" : lastName
    };
  }

  static void createUser (String id, String first, String last){

    FirebaseFirestore.instance.collection("users").doc(id).set({
      "id" : id,
      "FirstName" : first,
      "LastName" : last
    });
  }

  static void createUserWithPicture (String id, String first, String last, File pic)async{

    final profilePic = pic;
    final profilePicId = FirebaseAuth.instance.currentUser.uid+first;
    String picUrl;

    try {
      await FirebaseStorage.instance.ref("UsersProfilePic/$profilePicId").putFile(profilePic);
      picUrl = await FirebaseStorage.instance.ref("UsersProfilePic/$profilePicId").getDownloadURL();
      
    } catch (e) {
      print(e.toString());
    }

    FirebaseFirestore.instance.collection("users").doc(id).set({
      "id" : id,
      "ProfilePic" : picUrl,
      "FirstName" : first,
      "LastName" : last
    });
  }

  static Future<void> updateProfilePicToUser(HookedUser user, File pic) async{

    final profilePic = pic;
    final profilePicId = user.id+user.firstName;
    

    try {
      print(FirebaseAuth.instance.currentUser.uid);
      await FirebaseStorage.instance.ref("UsersProfilePic/$profilePicId").delete();

      await FirebaseStorage.instance.ref("UsersProfilePic/$profilePicId").putFile(profilePic);
      final picUrl = await FirebaseStorage.instance.ref("UsersProfilePic/$profilePicId").getDownloadURL();
      var userDoc = FirebaseFirestore.instance.collection("users").doc(user.id);
      
      await userDoc.set({
        "ProfilePic": picUrl,
      },SetOptions(merge: true));
      
    } catch (e) {
      print(e.toString());
    }

    // await FirebaseFirestore.instance.doc(user.id).update({
    //   "ProfilePic":picUrl
    // });

   

  }

  static Future<HookedUser> getUserbyId(String id) async {
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("/users").doc(FirebaseAuth.instance.currentUser.uid).get();

    var user = data.data();

    return HookedUser(user["id"], user["FirstName"], user["LastName"], user["ProfilePic"]);

  }

}