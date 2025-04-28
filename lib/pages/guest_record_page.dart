import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:frontend_for_admins/widgets/record_item_card.dart';

class _GuestRecord {
  _GuestRecord(
      {required this.id,
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
}

class GuestRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuestRecordPageState();
  }
}

class _GuestRecordPageState extends State<GuestRecordPage> {
  List<_GuestRecord> _guestRecords = [];

  @override
  void initState() {
    super.initState();
    _getAllRecords();
  }

  Future<Map<String, String>> getUserInfo(int uid) async {
    try {
      Response response = await ApiClient().dio.get("/user/get_user?uid=$uid");
      return {
        "name": response.data['data']['username'],
        "phone": response.data['data']['phone']
      };
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
      throw Exception(errorMessage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      throw Exception(e.toString());
    }
  }

  Future<void> _getAllRecords() async {
    try {
      Response response = await ApiClient().dio.get("/guest/get_all_records");
      List data = response.data['data'] ?? [];
      Map<int, Map<String, String>> userInfo = {};
      for (var item in data) {
        userInfo[item['ownerId']] = await getUserInfo(item['ownerId']);
      }

      setState(() {
        _guestRecords = data.map<_GuestRecord>((item) {
          return _GuestRecord(
              id: item['id'],
              enterTime: DateTime.parse(item['enterTime']),
              leaveTime: DateTime.parse(item['leaveTime']),
              guestName: item['guestName'],
              guestPhone: item['guestPhone'],
              entrance: item['entrance'],
              requestCode: item['requestCode'],
              qrCode: item['hash'],
              status: item['status'],
              ownerName: userInfo[item['ownerId']]!['name']!,
              ownerPhone: userInfo[item['ownerId']]!['phone']!);
        }).toList();
        _guestRecords.sort((a, b) => b.enterTime.compareTo(a.enterTime));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("通行记录"), centerTitle: true),
      body: SafeArea(
          child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: _guestRecords.isEmpty
                  ? Container(
                      alignment: Alignment.center, child: Text("没有访客通行记录"))
                  : ListView.builder(
                      itemCount: _guestRecords.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          SizedBox(height: 10),
                          RecordItemCard(
                            id: _guestRecords[index].id,
                            enterTime: _guestRecords[index].enterTime,
                            leaveTime: _guestRecords[index].leaveTime,
                            guestName: _guestRecords[index].guestName,
                            guestPhone: _guestRecords[index].guestPhone,
                            entrance: _guestRecords[index].entrance,
                            requestCode: _guestRecords[index].requestCode,
                            qrCode: _guestRecords[index].qrCode,
                            status: _guestRecords[index].status,
                            ownerName: _guestRecords[index].ownerName,
                            ownerPhone: _guestRecords[index].ownerPhone,
                          ),
                          if (index == _guestRecords.length - 1)
                            SizedBox(height: 10)
                        ]);
                      },
                    ))),
    );
  }
}
