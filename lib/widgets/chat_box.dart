import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:frontend_for_admins/utils/user_util.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<StatefulWidget> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool isSending = false;

  void _sendMessage() async {
    if (isSending) return;
    isSending = true;
    final text = _controller.text.trim();
    _controller.clear();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({'text': text, 'isMe': true});
      });
      try {
        Response response = await ApiClient().dio.post(
            "/ai/send_message_from_admin",
            data: {"uid": await UserUtil.getUid(), "message": text});
        bool success = response.data['data']['success'];
        String answer = response.data['data']['message'];
        if (success) {
          setState(() {
            messages.add({'text': answer, 'isMe': false});
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("失败：$answer")),
          );
        }
      } on DioException catch (e) {
        String errorMessage = e.toString();
        if (e.response != null &&
            e.response?.data != null &&
            e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        isSending = false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("不可发送空白消息"),
      ));
    }
    isSending = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isMe = message['isMe'] as bool;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message['text'] as String),
                ),
              );
            },
          ),
        ),
        Text(
          "结果由AI生成，有一定概率与真实情况不一致，请仔细鉴别",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 5),
        Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: '输入消息...',
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: isSending ? null : _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
