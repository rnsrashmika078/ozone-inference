import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> sendMessage(
  String prompt,
  String system,
  bool isFirst,
  history,
) async {
  final response = await http.post(
    Uri.parse("http://10.0.2.2:3000/api/generate/chat"),
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
