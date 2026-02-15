import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inference/main.dart';

Future<void> nativeGoogleSignIn() async {
  final webClientId = dotenv.env['WEB_CLIENT_ID'];
  final iosClientId = dotenv.env['IOS_CLIENT_ID'];
  final googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No access token found.';
  }

  if (idToken == null) {
    throw 'No ID token found.';
  }

  await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}

Future<void> emailSignIn(String email, String password) async {
  final res = await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );

  final user = res.user;
  if (user == null) {
    throw 'failed login.';
  }
}

Future<void> emailSignUp(String email, String password) async {
  final res = await supabase.auth.signUp(email: email, password: password);

  if (res.user == null) {
    throw 'failed signup.';
  }
}

Future<void> signOut() async {
  final webClientId = dotenv.env['WEB_CLIENT_ID'];
  final iosClientId = dotenv.env['IOS_CLIENT_ID'];
  final googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  await googleSignIn.signOut();
  await supabase.auth.signOut();
}
