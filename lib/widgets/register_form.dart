import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/utils/api_client.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 业主姓名输入框
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: '业主姓名',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入业主姓名';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          // 业主手机号输入框
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: '业主手机号',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入业主手机号';
              }
              if (value.length != 11) {
                return '手机号的长度必须为11位';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          // 业主门牌号输入框
          TextFormField(
            controller: _roomNumberController,
            decoration: InputDecoration(
              labelText: '业主门牌号',
              prefixIcon: Icon(Icons.door_back_door),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入业主门牌号';
              }
              final pattern = RegExp(r'^\d{2}-\d{2}-\d{3}$');
              if (!pattern.hasMatch(value)) {
                return '门牌号格式应为"XX-XX-XXX"，且X为数字';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          // 注册按钮
          Ink(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await ApiClient().dio.post("/user/register", data: {
                      "phone": _phoneController.text,
                      "username": _usernameController.text,
                      "password": _phoneController.text
                          .substring(_phoneController.text.length - 6),
                      "roomNumber": _roomNumberController.text
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("注册成功，初始密码为手机号后6位，请及时提醒业主修改密码")));
                    Navigator.pop(context);
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
                  "注册",
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
