import 'package:flutter/material.dart';
import 'pages/project1_page.dart';  // Add this
import 'pages/project2_page.dart';  // Add this
import 'pages/project3_page.dart';  // Add this
import 'pages/project4_page.dart';  // Add this

void main() {
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
          padding: const EdgeInsets.all(16.0), // Adds padding around the GridView
          child: GridView.count(
            shrinkWrap: true, // Make the GridView smaller to fit content
            crossAxisCount: 2, // Number of columns
            mainAxisSpacing: 10, // Spacing between rows
            crossAxisSpacing: 10, // Spacing between columns
            children: [
              ProjectTile(
                image: 'assets/project1.png',  // Image file for Project 1
                title: 'Project 1',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Project1Page()), // Navigate to Project 1
                  );
                },
              ),
              ProjectTile(
                image: 'assets/project2.png',  // Image file for Project 2
                title: 'Project 2',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Project2Page()), // Navigate to Project 2
                  );
                },
              ),
              ProjectTile(
                image: 'assets/project3.png',  // Image file for Project 3
                title: 'Project 3',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleMapPage()), // Navigate to Project 3
                  );
                },
              ),
              ProjectTile(
                image: 'assets/project4.png',  // Image file for Project 4
                title: 'Project 4',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Project4Page()), // Navigate to Project 4
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
              height: 80,  // Set the height of the image to make it smaller
              width: double.infinity,
              child: Image.asset(image, fit: BoxFit.cover),  // Use BoxFit.cover to fill the available space
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
