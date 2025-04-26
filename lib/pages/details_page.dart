import 'package:flutter/material.dart';
import 'package:frontend_for_admins/widgets/details_card.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: Text('错误'), centerTitle: true),
        body: Center(child: Text('未收到参数')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("登记详情"), centerTitle: true),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(children: [
            SizedBox(height: 15),
            DetailsCard(
              enterTime: args['enterTime'] ?? DateTime.now(),
              leaveTime: args['leaveTime'] ?? DateTime.now(),
              guestName: args['guestName'] ?? "访客姓名",
              guestPhone: args['guestPhone'] ?? "访客手机号",
              requestCode: args['requestCode'] ?? "访问代码",
              qrCode: args['qrCode'] ?? "二维码",
              ownerName: args['ownerName'] ?? "业主姓名",
              ownerPhone: args['ownerPhone'] ?? "业主手机号",
            )
          ]),
        ),
      ),
    );
  }
}
