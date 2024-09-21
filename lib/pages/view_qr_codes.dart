import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

class ViewQRCodesPage extends StatefulWidget {
  const ViewQRCodesPage({super.key});

  @override
  State<ViewQRCodesPage> createState() => _ViewQRCodesPageState();
}

class _ViewQRCodesPageState extends State<ViewQRCodesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Codes List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('qrCodes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No QR codes found.'));
          }

          final qrCodes = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: qrCodes.length,
            itemBuilder: (context, index) {
              var qrCodeData = qrCodes[index];
              var code = qrCodeData['code'];
              var qrType = qrCodeData['qrType'];
              var timeStamp = (qrCodeData['timestamp'] as Timestamp).toDate();

              // Format the timestamp to a shorter format
              String formattedTime = DateFormat('MMM dd, yyyy – HH:mm').format(timeStamp);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: qrType == 'Scanned'
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    child: Icon(
                      qrType == 'Scanned'
                          ? Icons.qr_code_scanner
                          : Icons.qr_code_2,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: $qrType'),
                      Text('Saved on: $formattedTime'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
