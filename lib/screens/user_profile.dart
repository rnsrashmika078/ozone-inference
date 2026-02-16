import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inference/main.dart';
import 'package:inference/provider/global_provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return UserProfileBody();
  }
}

class UserProfileBody extends ConsumerStatefulWidget {
  const UserProfileBody({super.key});

  @override
  ConsumerState<UserProfileBody> createState() => _UserProfileBody();
}

class _UserProfileBody extends ConsumerState<UserProfileBody> {
  // Map<String, dynamic>? _authUserData;

  final authUser = supabase.auth.currentUser;
  final userId = supabase.auth.currentUser?.id;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authUserProvider);
    return Center(
      child: Column(
        children: [
          user?['email'] != null
              ? Column(
                  spacing: 2,
                  children: [
                    user?['dp'] != null
                        ? CircleAvatar(
                            radius: 34,
                            backgroundImage: NetworkImage(user?['dp']),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              user?['username'][0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                    Text(
                      user?['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(user?['email'], style: TextStyle(fontSize: 16)),
                  ],
                )
              : Column(
                  children: [
                    Image.asset("assets/images/user2.png", width: 100),
                    const Text(
                      "You are not logged in!",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
