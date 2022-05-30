import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/userdashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage;
  final _auth = FirebaseAuth.instance;
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  String? fcmToken;

  getToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.primary,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: CustomColors.secondary,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          top: 100,
                          right: 40,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Let\'s Get Started',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Let\'s Get You Signed In.',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputField(
                              controller: emailEditingController,
                              labelText: "Email",
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              controller: firstNameEditingController,
                              labelText: "First Name",
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              controller: secondNameEditingController,
                              labelText: "Last Name",
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              controller: passwordEditingController,
                              labelText: "Password",
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              controller: confirmPasswordEditingController,
                              labelText: "Confirm Password",
                            ),
                            const SizedBox(height: 20),
                            ButtonTheme(
                              minWidth: 200.0,
                              height: 100.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  signUp(emailEditingController.text.trim(),
                                      passwordEditingController.text.trim());
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  minimumSize: const Size(
                                      double.infinity, 60), //////// HERE
                                ),
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: CustomColors.secondary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
          (value) => {
            postDetailsToFirestore(),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserDashboard(),
              ),
            ),
          },
        )
        .catchError(
      (e) {
        switch (e.code) {
          case "invalid-email":
            Fluttertoast.showToast(
                msg: "Your email address appears to be malformed.");
            break;
          case "wrong-password":
            Fluttertoast.showToast(msg: "Your password is wrong.");
            break;
          case "user-not-found":
            Fluttertoast.showToast(msg: "User with this email doesn't exist.");
            break;
          case "user-disabled":
            Fluttertoast.showToast(
                msg: "User with this email has been disabled.");
            break;
          case "too-many-requests":
            Fluttertoast.showToast(msg: errorMessage = "Too many requests");
            break;
          case "operation-not-allowed":
            Fluttertoast.showToast(
                msg: "Signing in with Email and Password is not enabled.");
            break;
          default:
            Fluttertoast.showToast(msg: "An undefined Error happened.");
        }
      },
    );
  }

  postDetailsToFirestore() async {
    FirebaseFirestore.instance.collection('userNames').add(
      {
        'deviceToken': fcmToken.toString(),
        'firstName': firstNameEditingController.text.toTitleCase(),
        'lastName': secondNameEditingController.text.toTitleCase(),
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'date': DateFormat("MMMM dd, yyyy").format(DateTime.now()),
        'time': DateFormat("hh:mm:ss a").format(DateTime.now()),
        'rating': 0,
        'donationsCompleted': 0,
        'peopleHelped': 0,
        'foodSaved': 0,
        'hoursVolunteered': 0,
      },
    ).then(
      (value) {
        Fluttertoast.showToast(msg: "Account created successfully!");
      },
    );
  }
}
