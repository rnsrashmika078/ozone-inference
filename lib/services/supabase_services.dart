import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inference/main.dart';

Future<List<Map<String, dynamic>>> getAllUsers() async {
  return await supabase.from(dotenv.env['SUPABASE_TABLE']!).select();
}

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

Future<void> createChat(uId, String cId, String title) async {
  await supabase.from('chats').upsert({
    'uId': uId,
    'cId': cId,
    'title': title,
  }, onConflict: 'cId');
}

Future<void> createMessage(
  String cId,
  String mId,
  String role,
  String message,
) async {
  await supabase.from('messages').insert({
    'cId': cId,
    'mId': mId,
    'role': role,
    'message': message,
  });
}

Future<List<Map<String, dynamic>>> getChats(String uId) async {
  List<Map<String, dynamic>> chats = await supabase
      .from('chats')
      .select('cId,title,uId')
      .eq('uId', uId);

  if (chats.isNotEmpty) {
    return chats;
  }
  return [];
}

Future<List<Map<String, dynamic>>> getMessages(String cId) async {
  List<Map<String, dynamic>> messages = await supabase
      .from('messages')
      .select('cId, mId,message,role')
      .eq('cId', cId);

  if (messages.isNotEmpty) {
    return messages;
  }
  return [];
}
