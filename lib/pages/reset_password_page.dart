import 'package:flutter/material.dart';
import 'package:frontend_for_admins/widgets/reset_password_form.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordPageState();
  }
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("修改密码"), centerTitle: true),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  children: [ResetPasswordForm()],
                ))));
  }
}
