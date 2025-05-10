import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/pages/login_page.dart';

import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:frontend_for_admins/utils/user_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _originalPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  bool _obscureOriginalPwd = true;
  bool _obscureNewPwd = true;
  bool _obscureConfirmPwd = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 原密码
          TextFormField(
            controller: _originalPwdController,
            obscureText: _obscureOriginalPwd,
            decoration: InputDecoration(
              labelText: '原密码',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureOriginalPwd
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureOriginalPwd = !_obscureOriginalPwd;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入原密码';
              if (value.length < 6) return '密码长度不能少于6位';
              return null;
            },
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
                        .put("/admin/change_password_without_code", data: {
                      "uid": await UserUtil.getUid(),
                      "originalPassword": _originalPwdController.text,
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
