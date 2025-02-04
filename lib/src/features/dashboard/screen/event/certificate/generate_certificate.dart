import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateCertificate(String userName, String eventName, String eventDate) async {
  final pdf = pw.Document();

  // Load fonts from assets
  final fontRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto/Roboto-Regular.ttf'));
  final fontBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto/Roboto-Bold.ttf'));

  // Create PDF content
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "Certificate of Participation",
                style: pw.TextStyle(fontSize: 24, font: fontBold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("This is to certify that", style: pw.TextStyle(font: fontRegular)),
              pw.SizedBox(height: 10),
              pw.Text(
                userName,
                style: pw.TextStyle(fontSize: 20, font: fontBold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("has successfully attended the event", style: pw.TextStyle(font: fontRegular)),
              pw.SizedBox(height: 10),
              pw.Text(
                eventName,
                style: pw.TextStyle(fontSize: 20, font: fontBold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("held on", style: pw.TextStyle(font: fontRegular)),
              pw.SizedBox(height: 10),
              pw.Text(eventDate, style: pw.TextStyle(font: fontRegular)),
              pw.SizedBox(height: 40),
              pw.Text("Authorized Signature", style: pw.TextStyle(font: fontRegular)),
            ],
          ),
        );
      },
    ),
  );

  // Save the PDF
  Directory? saveDir;

  if (Platform.isAndroid) {
    if (await Permission.storage.request().isGranted) {
      saveDir = Directory('/storage/emulated/0/Download');
    } else {
      throw Exception("Storage permission denied");
    }
  } else if (Platform.isIOS) {
    saveDir = await getApplicationDocumentsDirectory();
  }

  if (saveDir != null) {
    final filePath = '${saveDir.path}/Certificate_$eventName.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    print("Certificate saved at $filePath");
  }
}
