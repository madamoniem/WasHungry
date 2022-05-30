import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../customwidgets.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);
  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText(
              text: 'Reset Password',
              fontSize: 35,
            ),
            const SizedBox(
              height: 15,
            ),
            InputField(
              controller: email,
              labelText: 'Email',
            ),
            const SizedBox(
              height: 15,
            ),
            // CustomButton(
            //   btnText: 'Send Instructions',
            //   onPressed: () {
            //     auth.sendPasswordResetEmail(email: email.text).then(
            //           (value) =>
            //               Fluttertoast.showToast(msg: "Instructions Sent"),
            //         );
            //     Navigator.of(context).pop();
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
