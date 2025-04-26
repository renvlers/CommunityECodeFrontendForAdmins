import 'package:flutter/material.dart';

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scanBoxSize = width * 0.6; // 扫描框宽度占屏幕60%
        final left = (width - scanBoxSize) / 2;
        final top = (height - scanBoxSize) / 2;

        return Stack(
          children: [
            // 外层遮罩
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  // 整个黑色背景
                  Container(
                    width: width,
                    height: height,
                    color: Colors.black,
                  ),
                  // 中间透明的扫描框
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: scanBoxSize,
                      height: scanBoxSize,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 边框
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: scanBoxSize,
                height: scanBoxSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
