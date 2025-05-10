import 'package:flutter/material.dart';
import 'package:frontend_for_admins/widgets/chat_box.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<StatefulWidget> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能助手'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ChatBox(),
        ),
      ),
    );
  }
}
