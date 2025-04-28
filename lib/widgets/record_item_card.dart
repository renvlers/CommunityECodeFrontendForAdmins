import 'package:flutter/material.dart';
import 'package:frontend_for_admins/utils/date_time_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecordItemCard extends StatefulWidget {
  const RecordItemCard(
      {super.key,
      required this.id,
      required this.enterTime,
      required this.leaveTime,
      required this.guestName,
      required this.guestPhone,
      required this.entrance,
      required this.requestCode,
      required this.qrCode,
      required this.status,
      required this.ownerName,
      required this.ownerPhone});

  final int id;
  final DateTime enterTime;
  final DateTime leaveTime;
  final String guestName;
  final String guestPhone;
  final String entrance;
  final String requestCode;
  final String qrCode;
  final int status;
  final String ownerName;
  final String ownerPhone;

  @override
  State<StatefulWidget> createState() {
    return _RecordItemCardState();
  }
}

class _RecordItemCardState extends State<RecordItemCard> {
  late final int id;
  late final DateTime enterTime;
  late final DateTime leaveTime;
  late final String guestName;
  late final String guestPhone;
  late final String entrance;
  late final int ownerId;
  late final String requestCode;
  late final String qrCode;
  late final int status;
  late final String ownerName;
  late final String ownerPhone;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    enterTime = widget.enterTime;
    leaveTime = widget.leaveTime;
    guestName = widget.guestName;
    guestPhone = widget.guestPhone;
    entrance = widget.entrance;
    requestCode = widget.requestCode;
    qrCode = widget.qrCode;
    status = widget.status;
    ownerName = widget.ownerName;
    ownerPhone = widget.ownerPhone;
  }

  String _getStatus(int statusId) {
    switch (statusId) {
      case 0:
        return "已过期";
      case 1:
        return "已允许";
      case 2:
        return "已拒绝";
      case 3:
        return "已撤回";
    }
    return "未知状态";
  }

  Color _getCardColorByStatusId(int statusId) {
    switch (statusId) {
      case 0:
        return Color.fromARGB(255, 183, 211, 255);
      case 1:
        return Color.fromARGB(255, 205, 255, 183);
      case 2:
        return Color.fromARGB(255, 255, 190, 190);
      case 3:
        return Color.fromARGB(255, 255, 250, 184);
    }
    return Color.fromARGB(255, 217, 217, 217);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: _getCardColorByStatusId(status), // 此处卡片的背景颜色应当取决于该记录的状态
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.access_time_outlined),
                SizedBox(width: 6),
                Text(
                    "${DateTimeUtil.getString(enterTime)} - ${DateTimeUtil.getString(leaveTime)}")
              ]),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.person_outlined),
                SizedBox(width: 6),
                Text(guestName)
              ]),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.phone_outlined),
                SizedBox(width: 6),
                Text(guestPhone)
              ]),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.door_front_door_outlined),
                SizedBox(width: 6),
                Text(entrance)
              ]),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.info_outlined),
                SizedBox(width: 6),
                Text(_getStatus(status))
              ])
            ],
          ),
          SizedBox(height: 10),
          Text("由业主$ownerName登记，如有疑问请联系$ownerPhone"),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Column(
            children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SizedBox(
                              width: 200, // 固定宽度
                              height: 261, // 固定高度
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text(
                                        requestCode,
                                        style: TextStyle(fontSize: 36),
                                      ),
                                      SizedBox(height: 10),
                                      QrImageView(
                                        data: qrCode,
                                        version: QrVersions.auto,
                                        size: 200,
                                      ),
                                    ],
                                  ))),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('关闭'),
                            ),
                          ],
                        ),
                      );
                    } catch (e, stack) {
                      print("显示二维码失败: $e");
                      print(stack);
                    }
                  },
                  icon: Icon(Icons.more_horiz),
                  label: Text("查看更多信息"),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)))))
            ],
          )
        ]));
  }
}
