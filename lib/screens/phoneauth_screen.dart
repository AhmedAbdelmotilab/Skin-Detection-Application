// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore

import 'dart:async';

import 'package:blocauth/provider/internet_provider.dart';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/home_screen.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/config.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:blocauth/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  String? _emailValidationError;

  @override
  Widget build(BuildContext context) {
    final Widget backButton = IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 24,
      ),
      onPressed: () => nextScreenReplace(context, const LoginScreen()),
    );

    const Widget title = Text(
      "Phone Registration",
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: "Times New Roman",
        fontWeight: FontWeight.bold,
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: backButton,
          title: title,
          centerTitle: true,
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
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
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Image(
                            image: AssetImage(Config.app_icon),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            color: Color.fromRGBO(68, 138, 255, 1),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Welcome to the application",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Enter Your First And Last Name",
                            labelStyle: const TextStyle(
                              fontFamily: "Times New Roman",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: const Icon(Icons.account_circle),
                            hintText: "First and Last Name",
                            hintStyle: const TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: "Times New Roman",
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email address cannot be empty";
                            } else if (!RegExp(r'^\S+@\S+\.\S+$')
                                .hasMatch(value)) {
                              setState(() {
                                _emailValidationError =
                                    'Please enter a valid email address';
                              });
                              return _emailValidationError;
                            } else {
                              setState(() {
                                _emailValidationError = null;
                              });
                              return null;
                            }
                          },
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Enter Your Email Address",
                            labelStyle: const TextStyle(
                              fontFamily: "Times New Roman",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: const Icon(Icons.email),
                            hintText: "example@example.com",
                            hintStyle: const TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: "Times New Roman",
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            errorText: _emailValidationError,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: "Enter Your Phone Number",
                            labelStyle: const TextStyle(
                              fontFamily: "Times New Roman",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: "1234567890",
                            hintStyle: const TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: "Times New Roman",
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          initialCountryCode:
                              'EG', // set the default country code
                          onChanged: (phone) {
                            // update the controller value with the full phone number
                            phoneController.text = phone.completeNumber;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              login(context, phoneController.text.trim());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 5.0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 32.0),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Times New Roman",
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();

    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      // ignore: use_build_context_synchronously
      openSnackbar(context, "Check Your Internet Connection", Colors.red);
    } else {
      if (formkey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobile,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnackbar(context, e.toString(), Colors.red);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Enter OTP Code",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Times New Roman",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: otpCodeController,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return 'Please enter a 6-digit code';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.code),
                              labelText: "OTP Code",
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                final code = otpCodeController.text.trim();
                                AuthCredential authCredential =
                                    PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code,
                                );
                                User user = (await FirebaseAuth.instance
                                        .signInWithCredential(authCredential))
                                    .user!;
                                // SAVE THE DATA
                                sp.phonNumberUser(user, emailController.text,
                                    nameController.text);
                                //Checking whether the user exists or not.
                                sp.checkUserExists().then(
                                  (value) async {
                                    if (value == true) {
                                      //user exist
                                      await sp
                                          .getUserDataFromFirestore(sp.uid)
                                          .then(
                                            (value) => sp
                                                .saveDataToSharedPreferences()
                                                .then(
                                                  (value) =>
                                                      sp.setSignIn().then(
                                                    (value) {
                                                      nextScreenReplace(context,
                                                          const HomeScreen());
                                                    },
                                                  ),
                                                ),
                                          );
                                    } else {
                                      //user not exist
                                      sp.saveDataToFirestore().then(
                                            (value) => sp
                                                .saveDataToSharedPreferences()
                                                .then(
                                                  (value) =>
                                                      sp.setSignIn().then(
                                                    (value) {
                                                      nextScreenReplace(
                                                        context,
                                                        const HomeScreen(),
                                                      );
                                                    },
                                                  ),
                                                ),
                                          );
                                    }
                                  },
                                );
                              } catch (e) {
                                // Handle any errors that might occur.
                                print('An error occurred: $e');
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Error',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Times New Roman",
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'An error occurred while processing your request.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0,
                                                  vertical: 8.0),
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .blue, // Change the button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Change the button border radius
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16), // Change the button padding
                            ),
                            child: const Text(
                              "Confirm",
                              style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 18, // Change the button text size
                                fontWeight: FontWeight
                                    .bold, // Change the button text weight
                                color: Colors
                                    .white, // Change the button text color
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: mobile,
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    if (e.code == 'invalid-phone-number') {
                                      print(
                                          'The provided phone number is not valid.');
                                    } else {
                                      print(
                                          'Verification failed. Code: ${e.code}. Message: ${e.message}');
                                    }
                                  },
                                  codeSent: (String verificationId,
                                      int? forceResendingToken) {
                                    print('OTP code sent successfully!');
                                    verificationId = verificationId;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'OTP code sent successfully!',
                                          style: TextStyle(
                                            fontFamily: "Times New Roman",
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );
                              } on FirebaseAuthException catch (e) {
                                print(
                                    'Error sending OTP code: ${e.code}. Message: ${e.message}');
                              }
                            },
                            child: const Text("Resend OTP"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}
