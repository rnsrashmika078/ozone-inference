import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadChats();
    });
  }

  Future<void> _loadChats() async {
    final uId = supabase.auth.currentSession?.user.id;

    List<Map<String, dynamic>> data = await getChats(uId!);
    if (!mounted) [];
    setState(() {
      chats = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(authUserProvider);
    final selection = ref.watch(navigationProvider);

    final List<Map<String, dynamic>> drawerItems = [
      {'title': 'MARKETPLACE', 'icon': Icons.home},
      {'title': 'PROFILE', 'icon': Icons.person},
    ];
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, top: 50,bottom: 20),
            child: UserProfile(),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20, 
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 2),
                  child: Container(
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        chat['title'] ?? "",
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
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("SIGN OUT"),
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
 // children: drawerItems.map((item) {
            //   return Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            //     decoration: BoxDecoration(
            //       color: item['title'] == selection
            //           ? Color.fromARGB(141, 0, 107, 246)
            //           : Color.fromARGB(0, 255, 255, 255),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: ListTile(
            //       leading: Icon(item['icon']),
            //       title: Text(item['title']),
            //       onTap: () => {
            //         setState(() {
            //           ref.read(navigationProvider.notifier).state =
            //               item['title'];
            //         }),
            //         // Navigator.pop(context)
            //       },
            //     ),
            //   );
            // }).toList(),