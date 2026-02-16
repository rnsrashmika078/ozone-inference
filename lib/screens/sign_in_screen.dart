import 'package:flutter/material.dart';
import 'package:inference/widgets/custom_app_bar.dart';
import 'package:inference/widgets/custom_drawer.dart';
import 'package:inference/widgets/sign_in_form_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(title: "Ozone"),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            Text(
              "Login to your account",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SignInForm(),
          ],
        ),
      ),
    );
  }
}
