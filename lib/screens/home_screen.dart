import 'package:blocauth/model/TfliteModel.dart';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/login_screen.dart';
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
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage("${sp.imageurl}"),
            radius: 50,
          ),
          const SizedBox(height: 20),
          Text(
            "Welcome ${sp.name}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${sp.email}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Provider"),
              const SizedBox(
                width: 5,
              ),
              Text(
                "${sp.provider}".toUpperCase(),
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              sp.userSignOut();
              nextScreenReplace(context, const LoginScreen());
            },
            child: const Text(
              "Sign out",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              nextScreenReplace(context, const TfliteModel());
            },
            child: const Text(
              "Test Your Skin ",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ));
  }
}
