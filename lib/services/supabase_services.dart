import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:inference/main.dart';

Future<void> insertData(
  String? userId,
  String? email,
  String? username,
  String? dp,
) async {
 
  await supabase.from(dotenv.env['SUPABASE_TABLE']!).upsert({
    'user_id': userId,
    'email': email,
    'username': username,
    'dp': dp,
  }, onConflict: 'user_id');
}

Future<Map<String, dynamic>?> getUserData(String userId) async {
  Map<String, dynamic>? user = await supabase
      .from(dotenv.env['SUPABASE_TABLE']!)
      .select('user_id,username, dp,email')
      .eq('user_id', userId)
      .maybeSingle();

  if (user!.isNotEmpty) {
    return user;
  }
  return null;
}

Future<List<Map<String, dynamic>>> getAllUsers() async {
  return await supabase.from(dotenv.env['SUPABASE_TABLE']!).select();
}
