import 'package:flutter/material.dart';
import 'package:inference/widgets/sign_up_form_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Create Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          Text(
            "Create a new Account",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SignUpForm(),
        ],
      ),
    );
  }
}
