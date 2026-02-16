import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/provider/global_provider.dart';
import 'package:inference/screens/user_profile.dart';
import 'package:inference/services/supabase_auth.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomDrawer();
}

class _CustomDrawer extends ConsumerState<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(authUserProvider);
    final selection = ref.watch(navigationProvider);

    final List<Map<String, dynamic>> drawerItems = [
      {'title': 'MARKETPLACE', 'icon': Icons.home},
      {'title': 'PROFILE', 'icon': Icons.person},
    ];
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [UserProfile()],
            ),
          ),
          Column(
            children: drawerItems.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: item['title'] == selection
                      ? Color.fromARGB(141, 0, 107, 246)
                      : Color.fromARGB(0, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  onTap: () => {
                    setState(() {
                      ref.read(navigationProvider.notifier).state =
                          item['title'];
                    }),
                    // Navigator.pop(context)
                  },
                ),
              );
            }).toList(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("SIGN OUT"),
              onTap: () async {
                await signOut();
                if (!context.mounted) return;
                Navigator.pop(context);
                ref.read(authUserProvider.notifier).state = null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
