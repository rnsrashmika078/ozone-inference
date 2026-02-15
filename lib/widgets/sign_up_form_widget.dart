import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/screens/sign_in_screen.dart';
import 'package:inference/services/supabase_auth.dart';
import 'package:inference/validator/form_validator.dart';
import 'package:inference/widgets/button_widget.dart';
import 'package:inference/widgets/custom_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpForm();
}

class _SignUpForm extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      ref.read(userNameProvider.notifier).state = username.text;
      ref.read(authUserProvider.notifier).state = {
        'username': username,
        'email': email,
      };
      await emailSignUp(email.text.trim(), password.text.trim());
      // await insertData(user_id, email.text.trim(), username.text.trim(), null);
      Fluttertoast.showToast(
        msg: "Registration Success!",
        gravity: ToastGravity.BOTTOM,
      );
      if (!context.mounted || !mounted) {
        return;
      }

      // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          spacing: 14,
          children: [
            CustomTextField(
              controller: username,
              labelText: 'Name',
              hintText: 'Enter username',
              prefixIcon: Icons.email_outlined,
              suffixIcon: Icons.check_circle_outline,
              validator: FormValidator.username,
            ),
            CustomTextField(
              controller: email,
              labelText: 'Email',
              hintText: 'Enter Your Email Address',
              prefixIcon: Icons.email_outlined,
              suffixIcon: Icons.check_circle_outline,
              validator: FormValidator.email,
            ),
            CustomTextField(
              controller: password,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              suffixIcon: Icons.check_circle_outline,
              validator: FormValidator.password,
            ),
            CustomButton(
              backgroundColor: Colors.blue,
              iconSize: 25,
              textColor: Colors.white,
              buttonText: "Create Account",
              onPressed: submitForm,
            ),
            Text("OR", style: TextStyle(color: Colors.grey, fontSize: 16)),
            // sign in with google
            CustomButton(
              backgroundColor: Colors.black,
              iconSize: 25,
              textColor: Colors.white,
              buttonText: "Sign in with Google",
              onPressed: () async {
                if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
                  await nativeGoogleSignIn();
                  if (!context.mounted) {
                    return;
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => UserProfile()),
                  // );
                } else {
                  await supabase.auth.signInWithOAuth(OAuthProvider.google);
                }
              },
              buttonIcon: ("assets/images/google_2.png"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
