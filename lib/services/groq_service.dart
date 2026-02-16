import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> sendMessage(
  String prompt,
  String system,
  bool isFirst,
  history,
) async {


  final response = await http.post(
    Uri.parse("${dotenv.env['PRODUCTION']}/api/generate/chat"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "prompt": prompt,
      "system": system,
      "isFirst": isFirst,
      "history": history,
    }),
  );

  final data = jsonDecode(response.body);
  return {"reply": data["reply"], "title": data["title"]};
}
