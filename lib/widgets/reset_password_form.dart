import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/pages/login_page.dart';
import 'dart:async';

import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  bool _obscureNewPwd = true;
  bool _obscureConfirmPwd = true;

  int _secondsRemaining = 0;
  Timer? _timer;

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
        if (_secondsRemaining <= 0) {
          _timer?.cancel();
        }
      });
    });
  }

  void _getSmsCode() async {
    if (_secondsRemaining > 0) return;

    final phone = _phoneController.text;
    if (phone.isEmpty || phone.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入正确的手机号')),
      );
      return;
    }

    try {
      await ApiClient().dio.post("/user/send_code", data: {"phone": phone});
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

    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 手机号
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '手机号',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入手机号';
              if (value.length != 11) return '手机号格式错误';
              return null;
            },
          ),
          SizedBox(height: 16),

          // 验证码
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '验证码',
                    prefixIcon: Icon(Icons.message),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入验证码';
                    if (value.length != 6) return '验证码为6位数字';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 220, 233, 255)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(21)),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: _secondsRemaining > 0 ? null : _getSmsCode,
                child: Text(
                    _secondsRemaining > 0
                        ? '重新获取 ($_secondsRemaining)'
                        : '获取验证码',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 16),

          // 新密码
          TextFormField(
            controller: _newPwdController,
            obscureText: _obscureNewPwd,
            decoration: InputDecoration(
              labelText: '新密码',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscureNewPwd ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureNewPwd = !_obscureNewPwd;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入新密码';
              if (value.length < 6) return '密码长度不能少于6位';
              return null;
            },
          ),
          SizedBox(height: 16),

          // 确认密码
          TextFormField(
            controller: _confirmPwdController,
            obscureText: _obscureConfirmPwd,
            decoration: InputDecoration(
              labelText: '确认密码',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPwd
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPwd = !_obscureConfirmPwd;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '请再次输入密码';
              if (value != _newPwdController.text) return '两次密码不一致';
              return null;
            },
          ),
          SizedBox(height: 24),

          // 提交按钮
          Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  // 处理修改密码逻辑
                  try {
                    Response response = await ApiClient()
                        .dio
                        .put("/user/change_password", data: {
                      "phone": _phoneController.text,
                      "verificationCode": _codeController.text,
                      "newPassword": _newPwdController.text
                    });
                    if (response.statusCode == 200) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
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
                padding: EdgeInsets.all(16),
                child: Text(
                  "修改密码",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
