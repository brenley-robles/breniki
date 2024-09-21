import 'package:breniki/pages/generate_code_page.dart';
import 'package:breniki/pages/scan_code_page.dart';
import 'package:breniki/pages/view_qr_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/project1_page.dart';  // Import Project 1 Page
import 'pages/project2_page.dart';  // Import Project 2 Page
import 'pages/project3_page.dart';  // Import Project 3 Page
import 'pages/project4_page.dart';  // Import Project 4 Page
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initializes Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Compilation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Compilation Dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              ProjectTile(
                image: 'assets/project1.png',  // Image for Project 1
                title: 'Machine Learning',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Project1Page()),  // Link to Project 1 Page
                  );
                },
              ),
              ProjectTile(
                image: 'assets/project3.png',  // Image for Project 3
                title: 'View QR Codes',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewQRCodesPage()),  // Link to Project 3 Page
                  );
                },
              ),
              ProjectTile(
                image: 'assets/project4.png',  // Image for Project 4
                title: 'QR Scanner',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanCodePage()),  // Link to Project 4 Page
                  );
                },
              ),
              ProjectTile(
                image: 'assets/project2.png',  // Image for Project 2
                title: 'QR Generate',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateCodePage()),  // Link to Project 2 Page
                  );
                },
              ),
              
              
              ProjectTile(
                image: 'assets/project5.png',  // Image for Project 3
                title: 'Google Maps',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleMapPage()),  // Link to Project 3 Page
                  );
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const ProjectTile({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
