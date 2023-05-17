// ignore_for_file: file_names

import 'package:blocauth/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About Page'),
          centerTitle: true,
          backgroundColor: Colors
              .transparent, // Set a transparent background color for the AppBar
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF7F50),
                  Colors.pink
                ], // Mixed color of pink and orange
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'About Skin Detection App',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Our application helps you to know the type of skin disease you have, as it presents you with several possible options in possible proportions that help you and your doctor limit the possible options and determine the disease faster and more accurately.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 126, 126, 126),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'We are a group of students who are passionate about making applications that make people is lives better and easier, so we designed this application just for you.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 126, 126, 126),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.mail_outline_rounded, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'AhmedAbdelmotilab@gmail.com',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 126, 126, 126),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.phone_outlined, size: 22),
                        SizedBox(width: 10),
                        Text(
                          '+20 155-313-0965',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 126, 126, 126),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Alexandria,Egypt',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 126, 126, 126),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
