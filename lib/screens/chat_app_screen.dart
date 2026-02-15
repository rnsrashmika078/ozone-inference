import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/services/groq_service.dart';
import 'package:inference/services/supabase_services.dart';
import 'package:uuid/uuid.dart';

class ChatArea extends ConsumerStatefulWidget {
  const ChatArea({super.key});

  @override
  ConsumerState<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends ConsumerState<ChatArea> {
  List<Map<String, dynamic>> messages = [];
  final uId = supabase.auth.currentSession?.user.id;
  final textInputController = TextEditingController();
  String? title;
  String? cId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadMessage();
    });
  }

  Future<void> _loadMessage() async {
    List<Map<String, dynamic>> data = await getMessages(
      "a41ba458-d906-4a82-97d3-ae2eb04546af",
    );
    if (!mounted) [];
    setState(() {
      messages = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authUserProvider);
    final userName = user?["username"];
    final uuid = Uuid();
    print("user id:  $uId");

    final system =
        "You are a helpful AI assistant. Answer short and clearly.user name: $userName";
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 47, 47, 47),
              ),
              child: title != null
                  ? Text(
                      title ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment: msg['role'] == "user"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: msg['role'] == "user"
                            ? const Color.fromARGB(255, 51, 51, 51)
                            : const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          msg['message'] ?? "",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                onSubmitted: (value) async {
                  setState(() {
                    messages.add({
                      "id": messages.length + 1,
                      "role": "user",
                      "message": value,
                    });
                  });
                  Map<String, dynamic> reply = await sendMessage(
                    value,
                    system,
                    messages.length == 1,
                    messages,
                  );
                  setState(() {
                    title = reply['title'] ?? title;
                  });
                  if (messages.length == 1) {
                    final id = uuid.v4();
                    setState(() {
                      cId = id;
                    });
                    await createChat(uId, id, title!);
                  }
                  setState(() {
                    messages.add({
                      "id": messages.length + 1,
                      "role": "assistant",
                      "message": reply['reply'],
                    });
                  });
                  // save message to db
                  await Future.wait([
                    createMessage(cId!, uuid.v4(), 'user', value),
                    createMessage(cId!, uuid.v4(), 'assistant', reply['reply']),
                  ]);

                  textInputController.clear();
                },
                controller: textInputController,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  prefixIcon: Icon(Icons.add),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
