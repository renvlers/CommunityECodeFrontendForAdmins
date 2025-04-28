import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_admins/routes/routes.dart';
import 'package:frontend_for_admins/utils/api_client.dart';
import 'package:frontend_for_admins/widgets/qr_scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 相机画面
          MobileScanner(
            onDetect: (capture) async {
              // 这里可以处理扫描到的二维码
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? qrCode = barcodes.first.rawValue;
                if (qrCode != null) {
                  // 例如：弹窗显示二维码内容
                  try {
                    Response requestResponse = await ApiClient()
                        .dio
                        .get("/guest/check_request_by_qr_code?qrCode=$qrCode");
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
                    String qrCodeHash = requestResponse.data['data']['hash'];
                    String ownerName = ownerResponse.data['data']['username'];
                    String ownerPhone = ownerResponse.data['data']['phone'];
                    Navigator.pushNamed(context, RoutePath.detailsPage,
                        arguments: {
                          'enterTime': enterTime,
                          'leaveTime': leaveTime,
                          'guestName': guestName,
                          'guestPhone': guestPhone,
                          'requestCode': requestCode,
                          'qrCode': qrCodeHash,
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
              }
            },
          ),
          // 扫描框遮罩
          const QRScannerOverlay(),
          Positioned(
            top: 40, // 顶部留点距离（适配刘海屏）
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context); // 返回上一页
              },
            ),
          )
        ],
      ),
    );
  }
}
