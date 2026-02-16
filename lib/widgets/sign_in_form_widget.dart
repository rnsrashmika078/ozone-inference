import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/services/supabase_auth.dart';
import 'package:inference/validator/form_validator.dart';
import 'package:inference/widgets/button_widget.dart';
import 'package:inference/widgets/custom_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInForm();
}

class _SignInForm extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      ref.read(userNameProvider.notifier).state = username.text;
      ref.read(authUserProvider.notifier).state = {
        'username': username,
        'email': email,
      };
      await emailSignIn(email.text.trim(), password.text.trim());
      Fluttertoast.showToast(
        msg: "Successfully Signed-in!",
        gravity: ToastGravity.BOTTOM,
      );
      if (!context.mounted || !mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(20),
        child: Column(
          spacing: 14,
          children: [
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
              buttonText: "Continue to Login",
              onPressed: signIn,
            ),
            const Text(
              "OR",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
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
                } else {
                  await supabase.auth.signInWithOAuth(OAuthProvider.google);
                }
                if (!context.mounted || !mounted) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              buttonIcon: ("assets/images/google_2.png"),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
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
