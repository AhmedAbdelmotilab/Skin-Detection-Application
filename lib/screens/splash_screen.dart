import 'dart:async';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/home_screen.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/config.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //init state
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    //create atimer of 2 sec
    Timer(const Duration(seconds: 2), () {
      sp.isSignedIn == false
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Config.app_icon),
          fit: BoxFit.contain,
        ),
        color: Colors.blueGrey,
      ),
      child: Column(children: const [
        SizedBox(
          height: 650,
        ),
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
      ]),
    );
  }
}
