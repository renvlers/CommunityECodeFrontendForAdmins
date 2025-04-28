import 'package:flutter/material.dart';
import 'package:frontend_for_admins/widgets/register_form.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("新建业主账号"), centerTitle: true),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  children: [RegisterForm()],
                ))));
  }
}
