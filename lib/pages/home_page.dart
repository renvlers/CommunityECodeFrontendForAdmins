import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/pages/login_page.dart';
import 'package:frontend_for_admins/routes/routes.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:frontend_for_admins/utils/entrances_list.dart';
import 'package:frontend_for_admins/utils/user_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  int? uid;
  String? username;
  String? phone;
  String? roomNumber;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _initializeHomePage();
  }

  Future<void> _initializeUser() async {
    uid = await UserUtil.getUid() ?? 0;
    username = await UserUtil.getName() ?? "";
    phone = await UserUtil.getPhoneNumber() ?? "";
    roomNumber = await UserUtil.getRoomNumber() ?? "";
  }

  Future<void> _initializeHomePage() async {
    bool loggedIn = await _checkLoginStatus();

    if (loggedIn) {
      await _initializeUser();
    }
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      return false;
    }

    return true;
  }

  // 页面列表
  List<Widget> _buildPages(BuildContext context) {
    return [
      SafeArea(
        child: ListView(children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.qrCodeScannerPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/qr_code.png",
                            width: 80, height: 80),
                        Spacer(),
                        const Text(
                          "二维码验证",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () async {
                      String? code = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController codeController =
                              TextEditingController();
                          return AlertDialog(
                            title: Text("请输入6位访问代码"),
                            content: TextField(
                              controller: codeController,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "访问代码",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 取消
                                },
                                child: Text("取消"),
                              ),
                              TextButton(
                                onPressed: () {
                                  String code = codeController.text;
                                  if (code.length == 6)
                                    Navigator.of(context)
                                        .pop(code); // 返回输入的访问代码
                                  else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("访问代码长度不能小于6位")),
                                    );
                                },
                                child: Text("确定"),
                              ),
                            ],
                          );
                        },
                      );

                      if (code != null) {
                        try {
                          Response requestResponse = await ApiClient()
                              .dio
                              .get("/guest/check_request_by_code?code=$code");
                          Response ownerResponse = await ApiClient().dio.get(
                              "/user/get_user?uid=${requestResponse.data['data']['ownerId']}");
                          DateTime enterTime = DateTime.parse(
                              requestResponse.data['data']['enterTime']);
                          DateTime leaveTime = DateTime.parse(
                              requestResponse.data['data']['leaveTime']);
                          String guestName =
                              requestResponse.data['data']['guestName'];
                          String guestPhone =
                              requestResponse.data['data']['guestPhone'];
                          String requestCode =
                              requestResponse.data['data']['requestCode'];
                          String qrCode = requestResponse.data['data']['hash'];
                          String ownerName =
                              ownerResponse.data['data']['username'];
                          String ownerPhone =
                              ownerResponse.data['data']['phone'];
                          Navigator.pushNamed(context, RoutePath.detailsPage,
                              arguments: {
                                'enterTime': enterTime,
                                'leaveTime': leaveTime,
                                'guestName': guestName,
                                'guestPhone': guestPhone,
                                'requestCode': requestCode,
                                'qrCode': qrCode,
                                'ownerName': ownerName,
                                'ownerPhone': ownerPhone
                              });
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
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/request_code.png",
                            width: 80, height: 80),
                        Spacer(),
                        const Text(
                          "访客代码验证",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () async {
                      String? phoneNumber = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController codeController =
                              TextEditingController();
                          return AlertDialog(
                            title: Text("请输入访客手机号"),
                            content: TextField(
                              controller: codeController,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "手机号",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 取消
                                },
                                child: Text("取消"),
                              ),
                              TextButton(
                                onPressed: () {
                                  String code = codeController.text;
                                  if (code.length == 11)
                                    Navigator.of(context)
                                        .pop(code); // 返回输入的访问代码
                                  else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("请输入正确的手机号")),
                                    );
                                },
                                child: Text("确定"),
                              ),
                            ],
                          );
                        },
                      );

                      if (phoneNumber != null) {
                        try {
                          Response requestResponse = await ApiClient().dio.get(
                              "/guest/check_request_by_phone?phone=$phoneNumber");
                          Response ownerResponse = await ApiClient().dio.get(
                              "/user/get_user?uid=${requestResponse.data['data']['ownerId']}");
                          DateTime enterTime = DateTime.parse(
                              requestResponse.data['data']['enterTime']);
                          DateTime leaveTime = DateTime.parse(
                              requestResponse.data['data']['leaveTime']);
                          String guestName =
                              requestResponse.data['data']['guestName'];
                          String guestPhone =
                              requestResponse.data['data']['guestPhone'];
                          String requestCode =
                              requestResponse.data['data']['requestCode'];
                          String qrCode = requestResponse.data['data']['hash'];
                          String ownerName =
                              ownerResponse.data['data']['username'];
                          String ownerPhone =
                              ownerResponse.data['data']['phone'];
                          Navigator.pushNamed(context, RoutePath.detailsPage,
                              arguments: {
                                'enterTime': enterTime,
                                'leaveTime': leaveTime,
                                'guestName': guestName,
                                'guestPhone': guestPhone,
                                'requestCode': requestCode,
                                'qrCode': qrCode,
                                'ownerName': ownerName,
                                'ownerPhone': ownerPhone
                              });
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
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/phone.png",
                            width: 80, height: 80),
                        Spacer(),
                        const Text(
                          "手机号验证",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.guestRecordPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/guest_record.png",
                            width: 80, height: 80),
                        Spacer(),
                        const Text(
                          "访客记录查询",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.registerPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/new_account.png",
                            width: 80, height: 80),
                        Spacer(),
                        const Text(
                          "新建业主账号",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
        ]),
      ),
      SafeArea(
          child: Container(
              margin: EdgeInsets.all(10),
              child: ListView(children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 217, 237, 255),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      Icon(Icons.person_outline_rounded,
                          color: Colors.black, size: 96),
                      SizedBox(width: 30),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username ?? "物管账号用户名",
                                style: TextStyle(fontSize: 20)),
                            Text(phone ?? "物管电话号码"),
                          ]),
                      Spacer(),
                    ])),
                SizedBox(height: 16),
                Text("当前入口"),
                SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: EntrancesList.entrances.isNotEmpty
                      ? EntrancesList.entrances.first.id
                      : null,
                  items: EntrancesList.entrances
                      .map((e) => DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (int? value) async {
                    if (value != null) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt("entrance", value);
                      setState(() {
                        EntrancesList.entrances.sort((a, b) => a.id == value
                            ? -1
                            : b.id == value
                                ? 1
                                : a.id.compareTo(b.id));
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: Ink(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.resetPasswordPage);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text("修改密码",
                                      style: TextStyle(color: Colors.white)),
                                )))),
                    SizedBox(width: 10),
                    Expanded(
                        child: Ink(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("提示"),
                                        content: Text("你确定要退出吗？"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 关闭对话框
                                            },
                                            child: Text("取消"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _logout();
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                                (route) => false,
                                              ); // 跳转到登录页面并清除导航栈
                                            },
                                            child: Text("确定"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text("退出登录",
                                      style: TextStyle(color: Colors.white)),
                                ))))
                  ],
                )
              ])))
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _title = [Text("首页"), Text("我的")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title[_selectedIndex],
        centerTitle: true,
      ),
      body: _buildPages(context)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
