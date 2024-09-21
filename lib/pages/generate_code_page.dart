import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GenerateCodePage extends StatefulWidget {
  const GenerateCodePage({super.key});

  @override
  State<GenerateCodePage> createState() => _GenerateCodePageState();
}

class _GenerateCodePageState extends State<GenerateCodePage> {
  final List<String> _generatedCodes = [];
  String? qrData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Function to save the generated QR code to Firestore
  Future<void> _saveGeneratedCodeToFirestore(String code) async {
    try {
      await _firestore.collection('qrCodes').add({
        'code': code,
        'qrType': 'Generated', // Add qrType as 'Generated'
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Generated QR code saved to Firestore: $code');
    } catch (e) {
      print('Failed to save generated QR code: $e');
    }
  }

  // Function to open history page
  void _openHistoryPage() {
    Navigator.pushNamed(
      context,
      "/history",
      arguments: {
        'scannedCodes': [], // Pass empty list for scanned codes
        'generatedCodes': List<String>.from(_generatedCodes),
      },
    );
  }

  // Function to open log page
  void _openLogPage() {
    Navigator.pushNamed(
      context,
      "/log",
      arguments: {
        'scannedCodes': [], // Pass empty list for scanned codes
        'generatedCodes': List<String>.from(_generatedCodes),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.popAndPushNamed(context, "/scan");
        //     },
        //     icon: const Icon(Icons.qr_code_scanner),
        //   ),
        //   IconButton(
        //     onPressed: _openHistoryPage,
        //     icon: const Icon(Icons.history),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onSubmitted: (value) {
                setState(() {
                  qrData = value;
                  if (qrData != null) {
                    _generatedCodes.add(qrData!);
                    _saveGeneratedCodeToFirestore(qrData!); // Save generated code to Firestore
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter data for QR code',
                filled: true,
                fillColor: Colors.pink.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (qrData != null)
              PrettyQrView.data(data: qrData!),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
