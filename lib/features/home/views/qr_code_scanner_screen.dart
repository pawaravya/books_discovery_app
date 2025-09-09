import 'package:books_discovery_app/shared/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcode) {
                AppLogger.showInfoLogs("BARCODEDATA" + barcode.toString());
                String? code;

                if (barcode.raw is Map) {
                  final raw = barcode.raw as Map;
                  if (raw["data"] is List) {
                    final data = raw["data"] as List;
                    if(data.isNotEmpty){
                    code = data[0]["rawValue"]?.toString();

                    }
                  }
                }

                if (code != null && code.isNotEmpty) {
                  Navigator.of(context).pop(code); // ✅ return result safely
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
