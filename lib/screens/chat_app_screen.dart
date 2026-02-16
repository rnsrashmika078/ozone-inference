import 'package:flutter/material.dart';

class ChatArea extends StatefulWidget {
  const ChatArea({super.key});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!mounted) return;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("HI")));
  }
}
