import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/screens/chat_app_screen.dart';
import 'package:inference/screens/user_profile.dart';
import 'package:inference/services/supabase_auth.dart';
import 'package:inference/services/supabase_services.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomDrawer();
}

class _CustomDrawer extends ConsumerState<CustomDrawer> {
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> delete = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadChats();
    });
  }

  Future<void> _loadChats() async {
    final state = ref.watch(isMutated);
    final stateChats = ref.watch(allChatsProvider);

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (!state && stateChats.isNotEmpty) {
      setState(() {
        chats = stateChats;
        isLoading = false;
      });
      ref.read(isMutated.notifier).state = false;
      return;
    }
    final uId = supabase.auth.currentSession?.user.id;
    final data = await getChats(uId!);
    ref.read(isMutated.notifier).state = false;
    ref.read(allChatsProvider.notifier).state = data;
    setState(() {
      chats = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatDetails = ref.watch(chatProvider);

    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 50,
              bottom: 20,
            ),
            child: const UserProfile(),
          ),
          const Divider(color: Colors.grey, thickness: 1, height: 20),
          Padding(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              leading: const Icon(Icons.new_label),
              title: const Text("New chat", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatArea(passedCId: "newchat_id123", title: "New Chat"),
                  ),
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Chats",
                style: TextStyle(
                  // color: Color.fromARGB(255, 0, 13, 255),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          isLoading
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(color: Colors.blue),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            color: chatDetails['cId'] == chat['cId']
                                ? Color.fromARGB(255, 114, 114, 114)
                                : Color.fromARGB(0, 39, 39, 39),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              chat['title'] ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                color: chatDetails['cId'] == chat['cId']
                                    ? Colors.white
                                    : const Color.fromARGB(255, 98, 98, 98),
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete chat"),
                                  content: Text(
                                    "Do you want to delete '${chat['title']}' chat?",
                                    style: TextStyle(fontSize: 14),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await deleteChat(chat['cId']);
                                        ref.read(isMutated.notifier).state =
                                            true;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "'${chat['title']}' Deleted!",
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(20),
                                          ),
                                        );
                                        ref.read(deletedChatId.notifier).state =
                                            chat['cId'];
                                        setState(() {
                                          chats.removeWhere(
                                            (c) => c['cId'] == chat['cId'],
                                          );
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("No"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatArea(
                                    passedCId: chat['cId'],
                                    title: chat['title'],
                                  ),
                                ),
                              );
                              ref.read(chatProvider.notifier).state = {
                                'cId': chat['cId'],
                                'title': chat['title'],
                              };
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign out", style: TextStyle(fontSize: 18)),
              onTap: () async {
                await signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
