import 'package:blocauth/model/TfliteModel.dart';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/config.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        body: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orangeAccent, Colors.pinkAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: 1,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage("${sp.imageurl}"),
                    radius: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome, ${sp.name}",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.white),
                  title: Text(
                    "${sp.email}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  subtitle: Text(
                    "Provider: ${sp.provider}".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.blueGrey,
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
                        backgroundColor: Colors.red,
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
