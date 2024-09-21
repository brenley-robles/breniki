import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  final List<String> _scannedCodes = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Function to save the scanned QR code to Firestore
  Future<void> _saveScannedCodeToFirestore(String code) async {
    try {
      await _firestore.collection('qrCodes').add({
        'code': code,
        'qrType': "Scanned",
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('QR code saved to Firestore: $code');
    } catch (e) {
      print('Failed to save QR code: $e');
    }
  }

  // Function to open history page
  void _openHistoryPage() {
    Navigator.pushNamed(
      context,
      "/history",
      arguments: {
        'scannedCodes': List<String>.from(_scannedCodes),
        'generatedCodes': [], // Pass empty list for generated codes
      },
    );
  }

  // Function to open log page
  void _openLogPage() {
    Navigator.pushNamed(
      context,
      "/log",
      arguments: {
        'scannedCodes': List<String>.from(_scannedCodes),
        'generatedCodes': [], // Pass empty list for generated codes
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.popAndPushNamed(context, "/generate");
        //     },
        //     icon: const Icon(Icons.qr_code),
        //   ),
        //   IconButton(
        //     onPressed: _openHistoryPage,
        //     icon: const Icon(Icons.history),
        //   ),
        // ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            final code = barcode.rawValue;
            if (code != null && !_scannedCodes.contains(code)) {
              setState(() {
                _scannedCodes.add(code);
                _saveScannedCodeToFirestore(code); // Save scanned code to Firestore
              });
            }
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.pink.shade50,
                  title: Text(
                    barcodes.first.rawValue ?? "",
                    style: TextStyle(color: Colors.pink.shade800),
                  ),
                  content: Image(image: MemoryImage(image)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close', style: TextStyle(color: Colors.pink.shade800)),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
