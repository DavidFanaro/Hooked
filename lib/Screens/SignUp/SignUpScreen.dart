import 'package:Hooked/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const TextStyle txtStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      shadows: [Shadow(color: Colors.black, blurRadius: 10)]);

  static const InputDecoration usernameStyle = InputDecoration(
      border: OutlineInputBorder(), fillColor: Colors.white, filled: true);

  static const InputDecoration passwordStyle = InputDecoration(
    border: OutlineInputBorder(),
    fillColor: Colors.white,
    filled: true,
  );

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool vaildEmail = false;
  bool vaildPassword = false;

  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return false;
    else
      return true;
  }

  bool validatePassword(String value) {
    Pattern pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return false;
    else
      return true;
  }

  createHookedAccount(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.instance.currentUser.sendEmailVerification();
      HookedUser.createUser(
          FirebaseAuth.instance.currentUser.uid, firstName, lastName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  handleSubmit(BuildContext context) {
    Navigator.of(context).pop();
    String email = emailController.text;
    String password = passwordController.text;
    String first = firstNameController.text;
    String last = lastNameController.text;

    createHookedAccount(email, password, first, last);
  }

  @override
  Widget build(BuildContext context) {
    bool canSubmit = (vaildEmail && vaildPassword) &&
        (firstNameController.text != null && lastNameController.text != null);

    return Container(
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sign Up"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "First Name",
                      style: SignUpScreen.txtStyle,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: firstNameController,
                        decoration: SignUpScreen.usernameStyle,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        onSubmitted: canSubmit
                            ? (value) {
                                handleSubmit(context);
                              }
                            : null,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Last Name",
                      style: SignUpScreen.txtStyle,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: lastNameController,
                        decoration: SignUpScreen.usernameStyle,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        onSubmitted: canSubmit
                            ? (value) {
                                handleSubmit(context);
                              }
                            : null,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Email",
                      style: SignUpScreen.txtStyle,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: emailController,
                        decoration: SignUpScreen.usernameStyle,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        onSubmitted: canSubmit
                            ? (value) {
                                handleSubmit(context);
                              }
                            : null,
                        onChanged: (value) {
                          print(vaildEmail);
                          if (validateEmail(value)) {
                            setState(() {
                              vaildEmail = true;
                            });
                          } else {
                            setState(() {
                              vaildEmail = false;
                            });
                          }
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Password",
                      style: SignUpScreen.txtStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        if (validatePassword(value)) {
                          setState(() {
                            vaildPassword = true;
                          });
                        } else {
                          setState(() {
                            vaildPassword = false;
                          });
                        }
                      },
                      onSubmitted: canSubmit
                          ? (value) {
                              handleSubmit(context);
                            }
                          : null,
                      controller: passwordController,
                      obscureText: true,
                      decoration: SignUpScreen.usernameStyle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      RaisedButton(
                        onPressed: canSubmit
                            ? () {
                                handleSubmit(context);
                              }
                            : null,
                        disabledColor: Colors.grey,
                        color: Colors.green,
                        child: Text(
                          vaildEmail && vaildPassword ? "Create Account" : "",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      ),
    );
  }
}
