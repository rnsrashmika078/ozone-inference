import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/services/groq_service.dart';
import 'package:inference/services/supabase_services.dart';
import 'package:inference/widgets/custom_app_bar.dart';
import 'package:inference/widgets/custom_drawer.dart';
import 'package:uuid/uuid.dart';

class ChatArea extends ConsumerStatefulWidget {
  final String? passedCId;
  final String? title;
  const ChatArea({super.key, this.passedCId, this.title});
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
    List<Map<String, dynamic>> data = await getMessages(widget.passedCId ?? "");
    if (!mounted) [];
    setState(() {
      messages = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(deletedChatId, (prev, next) {
      if (next == null) return;

      if (widget.passedCId == next || cId == next) {
        setState(() {
          messages.clear();
          title = "New Chat";
        });
        if (mounted) Navigator.pop(context);
      }
    });
    final user = ref.watch(authUserProvider);
    final userName = user?["username"];
    final uuid = Uuid();
    final system =
        "You are a helpful AI assistant. Answer short and clearly.user name: $userName";
    return Scaffold(
      appBar: widget.passedCId != null
          ? CustomAppBar(title: title ?? widget.title ?? "")
          : null,
      drawer: widget.passedCId != null ? const CustomDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: messages.isNotEmpty
                  ? ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return Align(
                          alignment: msg['role'] == "user"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: msg['role'] == "user"
                                  ? const Color.fromARGB(255, 51, 51, 51)
                                  : const Color.fromARGB(255, 0, 0, 0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                msg['message'] ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.all(50),
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Meet Ozone. Your personal AI assistant. ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "I'm all yours ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      108,
                                      108,
                                      108,
                                    ),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Icon(Icons.cloud),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
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
                    ref.read(isMutated.notifier).state = true;
                    setState(() {
                      cId = id;
                    });
                    ref.read(chatProvider.notifier).state = {
                      'cId': cId,
                      'title': title,
                    };
                    await createChat(uId, id, title ?? "");
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
                    createMessage(
                      cId ?? widget.passedCId ?? "",
                      uuid.v4(),
                      'user',
                      value,
                    ),
                    createMessage(
                      cId ?? widget.passedCId ?? "",
                      uuid.v4(),
                      'assistant',
                      reply['reply'] ?? "",
                    ),
                  ]);

                  textInputController.clear();
                },
                controller: textInputController,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  prefixIcon: const Icon(Icons.add),
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
