import 'package:flutter/material.dart';
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
            onDetect: (capture) {
              // 这里可以处理扫描到的二维码
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
