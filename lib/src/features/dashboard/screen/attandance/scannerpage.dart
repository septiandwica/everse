import 'dart:convert';
import 'package:compuvers/src/features/dashboard/screen/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:compuvers/src/repository/attendance/attandance_repo.dart';

class QRCodeScannerPage extends StatefulWidget {
  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final AttendanceRepository attendanceRepo = Get.put(AttendanceRepository());
  late MobileScannerController scannerController;

  bool isTorchOn = false;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  void stopScannerAndGoToDashboard() async {
    await scannerController.stop();
    if (mounted) {
      Get.offAll(() => const UserDashboard());
    }
  }

  void toggleTorch() {
    scannerController.toggleTorch();
    setState(() {
      isTorchOn = !isTorchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Gunakan tema dari konteks

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code', style: theme.textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: stopScannerAndGoToDashboard,
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            fit: BoxFit.cover,
            onDetect: (barcodeCapture) async {
              final Barcode? barcode = barcodeCapture.barcodes.first;

              if (barcode == null || barcode.rawValue == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to scan QR code', style: theme.textTheme.bodyMedium)),
                );
                return;
              }

              final String qrData = barcode.rawValue!;
              try {
                final parsedData = jsonDecode(qrData);

                if (parsedData is! Map || !parsedData.containsKey('userId') || !parsedData.containsKey('eventId')) {
                  throw 'Invalid QR format';
                }

                final String userId = parsedData['userId'];
                final String eventId = parsedData['eventId'];

                final bool success = await attendanceRepo.markAttendance(eventId, userId);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Attendance marked for user: $userId', style: theme.textTheme.bodyMedium)),
                  );

                  Get.offAll(() => const UserDashboard());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to mark attendance. Please try again.', style: theme.textTheme.bodyMedium)),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to process QR: $e', style: theme.textTheme.bodyMedium)),
                );
              }
            },
          ),

          // Overlay Scan Box
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "torch_button",
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: toggleTorch,
                  child: Icon(
                    isTorchOn ? Icons.flash_on : Icons.flash_off,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                FloatingActionButton(
                  heroTag: "switch_camera_button",
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: () => scannerController.switchCamera(),
                  child: Icon(Icons.switch_camera, color: theme.colorScheme.onPrimary),
                ),
                FloatingActionButton(
                  heroTag: "close_button",
                  backgroundColor: theme.colorScheme.error,
                  onPressed: stopScannerAndGoToDashboard,
                  child: Icon(Icons.close, color: theme.colorScheme.onError),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}