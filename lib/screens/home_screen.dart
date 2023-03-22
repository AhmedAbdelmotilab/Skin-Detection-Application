// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:blocauth/model/TfliteModel.dart';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPrefernces();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    const Widget title = Text(
      "Your Profile",
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: "Times New Roman",
        fontWeight: FontWeight.bold,
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You cannot go back until you sign out.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: title,
          centerTitle: true,
          automaticallyImplyLeading: false, // this line removes the back button
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Flat.jpg'),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider<Object>?
                        : NetworkImage("${sp.imageurl}"),
                    radius: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome, ${sp.name}",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Times New Roman",
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.black),
                  title: Text(
                    "${sp.email}",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  subtitle: Text(
                    "Provider: ${sp.provider}".toUpperCase(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 93, 113, 123),
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        sp.userSignOut();
                        nextScreenReplace(context, const LoginScreen());
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        nextScreenReplace(context, const TfliteModel());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Test Your Skin",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
