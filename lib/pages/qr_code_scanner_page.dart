import 'dart:async';

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
  String? lastScannedQrCode;
  bool isProcessing = false;
  Timer? qrCodeResetTimer; // 新增一个Timer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 相机画面
          MobileScanner(
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              final String? qrCode =
                  barcodes.isNotEmpty ? barcodes.first.rawValue : null;

              if (qrCode == null) {
                return;
              }

              // 【新增】每次扫到二维码，重置计时器
              qrCodeResetTimer?.cancel();
              qrCodeResetTimer = Timer(Duration(seconds: 1), () {
                // 1秒后如果没有再次识别到同一个二维码，就清空记录
                lastScannedQrCode = null;
              });

              if (isProcessing || qrCode == lastScannedQrCode) {
                return;
              }

              isProcessing = true;
              lastScannedQrCode = qrCode;

              try {
                Response requestResponse = await ApiClient()
                    .dio
                    .get("/guest/check_request_by_qr_code?qrCode=$qrCode");
                Response ownerResponse = await ApiClient().dio.get(
                    "/user/get_user?uid=${requestResponse.data['data']['ownerId']}");

                MobileScannerController controller = MobileScannerController();
                await controller.stop();

                DateTime enterTime =
                    DateTime.parse(requestResponse.data['data']['enterTime']);
                DateTime leaveTime =
                    DateTime.parse(requestResponse.data['data']['leaveTime']);
                String guestName = requestResponse.data['data']['guestName'];
                String guestPhone = requestResponse.data['data']['guestPhone'];
                String requestCode =
                    requestResponse.data['data']['requestCode'];
                String qrCodeHash = requestResponse.data['data']['hash'];
                String ownerName = ownerResponse.data['data']['username'];
                String ownerPhone = ownerResponse.data['data']['phone'];

                Navigator.of(context).pop();

                isProcessing = false;

                Navigator.pushNamed(
                  context,
                  RoutePath.detailsPage,
                  arguments: {
                    'enterTime': enterTime,
                    'leaveTime': leaveTime,
                    'guestName': guestName,
                    'guestPhone': guestPhone,
                    'requestCode': requestCode,
                    'qrCode': qrCodeHash,
                    'ownerName': ownerName,
                    'ownerPhone': ownerPhone
                  },
                );
              } on DioException catch (e) {
                isProcessing = false;
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
                isProcessing = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
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
