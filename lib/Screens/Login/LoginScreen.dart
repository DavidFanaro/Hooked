import 'package:Hooked/Screens/SignUp/SignUpScreen.dart';
import 'package:Hooked/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

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
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool vaildEmail = false;
  bool vaildPassword = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

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

  loginHookedAccount(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          if (FirebaseAuth.instance.currentUser != null){
            try {
              HookedUser user = await HookedUser.getUserbyId(FirebaseAuth.instance.currentUser.uid);
            } catch (e) {
              print("Error error getting user data.");
            }
            
             
          }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("No user Found"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"))
            ],
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Wrong Password"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"))
            ],
          ),
        );
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Login",),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Email",
                    style: LoginScreen.txtStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
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
                    onSubmitted: vaildEmail && vaildPassword
                        ? (value) {
                            String email = emailController.text;
                            String password = passwordController.text;
                            loginHookedAccount(email, password, context);
                          }
                        : null,
                    controller: emailController,
                    decoration: SignUpScreen.usernameStyle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Password",
                    style: LoginScreen.txtStyle,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: SignUpScreen.usernameStyle,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      obscureText: true,
                      onSubmitted: vaildEmail && vaildPassword
                          ? (value) {
                              String email = emailController.text;
                              String password = passwordController.text;
                              // showDialog(
                              //     context: context,
                              //     child: AlertDialog(
                              //       title: Text("email: $email"),
                              //       content: Text("Password: $password"),
                              //     ));

                              loginHookedAccount(email, password, context);
                            }
                          : null,
                      onChanged: (value) {
                        // print(vaildPassword);
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
                    )),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Spacer(),
                    RaisedButton(
                      onPressed: vaildEmail && vaildPassword
                          ? () {
                              String email = emailController.text;
                              String password = passwordController.text;

                              

                              loginHookedAccount(email, password, context);
                            }
                          : null,
                      child: Text("Login",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Spacer(),
                    RaisedButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                                fullscreenDialog: true)),
                        child: Text(
                          "SignUp",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    Spacer()
                  ],
                )
              ],
            ),
          ),
        ),
        onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      ),
    );
  }
}
