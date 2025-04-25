import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/routes/routes.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveLoginInfo(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', userId);
    try {
      Response response =
          await ApiClient().dio.get("/user/get_user?uid=${userId}");
      if (response.statusCode == 200) {
        await prefs.setString('username', response.data['data']['username']);
        await prefs.setString('phone', response.data['data']['phone']);
        await prefs.setString(
            'roomNumber', response.data['data']['roomNumber']);
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
    }
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 账号输入框
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: '物管电话号码',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入电话号码';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          // 密码输入框
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: '密码',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入密码';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          // 登录按钮
          Ink(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  // 处理登录逻辑
                  try {
                    Response response =
                        await ApiClient().dio.post("/user/login", data: {
                      "phone": _usernameController.text,
                      "password": _passwordController.text,
                      "permission": 0
                    });
                    if (response.statusCode == 200 &&
                        response.data['message'] == "登录成功") {
                      int userId = response.data['data']['uid'];
                      print(userId);
                      await _saveLoginInfo(userId);
                      Navigator.pushReplacementNamed(
                          context, RoutePath.homePage);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(response.data['message'] ?? '用户名或密码错误')),
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
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(16),
                child: Text(
                  "登录",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
