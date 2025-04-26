import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:frontend_for_admins/utils/date_time_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailsCard extends StatefulWidget {
  final DateTime enterTime;
  final DateTime leaveTime;
  final String guestName;
  final String guestPhone;
  final String requestCode;
  final String qrCode;
  final String ownerName;
  final String ownerPhone;

  DetailsCard({
    super.key,
    required this.enterTime,
    required this.leaveTime,
    required this.guestName,
    required this.guestPhone,
    required this.requestCode,
    required this.qrCode,
    required this.ownerName,
    required this.ownerPhone,
  });

  @override
  State<StatefulWidget> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  late final DateTime enterTime;
  late final DateTime leaveTime;
  late final String guestName;
  late final String guestPhone;
  late final String requestCode;
  late final String qrCode;
  late final String ownerName;
  late final String ownerPhone;

  @override
  void initState() {
    super.initState();
    enterTime = widget.enterTime;
    leaveTime = widget.leaveTime;
    guestName = widget.guestName;
    guestPhone = widget.guestPhone;
    requestCode = widget.requestCode;
    qrCode = widget.qrCode;
    ownerName = widget.ownerName;
    ownerPhone = widget.ownerPhone;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 237, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Row(children: [
                Text(DateTimeUtil.getString(enterTime)),
                Spacer(),
                Container(
                  width: 48,
                  height: 1,
                  color: Colors.grey,
                ),
                Spacer(),
                Text(DateTimeUtil.getString(leaveTime))
              ]),
              SizedBox(height: 10),
              Row(children: [
                Icon(Icons.person),
                Text(guestName),
                Spacer(),
                Icon(Icons.phone),
                Text(guestPhone)
              ]),
              SizedBox(height: 24),
              Text(requestCode, style: TextStyle(fontSize: 36)),
              SizedBox(height: 10),
              QrImageView(data: qrCode, version: QrVersions.auto, size: 200),
              SizedBox(height: 24),
              Text("由业主$ownerName登记，如有疑问请联系$ownerPhone"),
              SizedBox(height: 10),
              Row(children: [
                ElevatedButton.icon(
                    onPressed: () async {},
                    icon: Icon(Icons.check, color: Colors.green),
                    label: Text("允许", style: TextStyle(color: Colors.green)),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))))),
                Spacer(),
                ElevatedButton.icon(
                    onPressed: () async {},
                    icon: Icon(Icons.close, color: Colors.red),
                    label: Text("拒绝", style: TextStyle(color: Colors.red)),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))))),
              ])
            ]))
      ],
    );
  }
}
