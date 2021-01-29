import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HookedUser {

  String id, firstName, lastName;
  
  HookedUser(this.id, this.firstName,this.lastName);

  

  static void createUser (String id, String first, String last){
    FirebaseFirestore.instance.collection("users").add({
        "FirstName": first,
        "LastName": last,
        "id": id
      });
  }

  static Future<HookedUser> getUserbyId(String id) async {
    QuerySnapshot data = await FirebaseFirestore.instance.collection("/users").where('id' , isEqualTo: id).get();

    QueryDocumentSnapshot user = data.docs.first;

    return HookedUser(user["id"], user["FirstName"], user["LastName"]);

  }

}