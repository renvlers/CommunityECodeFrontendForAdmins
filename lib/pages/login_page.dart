import 'package:flutter/material.dart';
import 'package:frontend_for_admins/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("登录"), centerTitle: true),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: ListView(children: [
              Container(
                height: 128,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/app_icon.png",
                  width: 96,
                  height: 96,
                ),
              ),
              SizedBox(height: 28),
              LoginForm()
            ]),
          ),
        ));
  }
}
