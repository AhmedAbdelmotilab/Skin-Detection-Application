import 'package:blocauth/provider/internet_provider.dart';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/home_screen.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/config.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:blocauth/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 131, 147),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            nextScreenReplace(context, const LoginScreen());
          },
        ),
        centerTitle: true, // set this property to true to center the title
        title: const Text(
          'Registration ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20, // set the font size
            fontFamily: 'Open Sans', // set the font family
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image(
                    image: AssetImage(Config.app_icon),
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Welcome to the application",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                    prefixIcon: const Icon(Icons.account_circle),
                    hintText: "First and Last Name",
                    hintStyle: const TextStyle(color: Colors.blueGrey),
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
                    } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)) {
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
                    prefixIcon: const Icon(Icons.email),
                    hintText: "example@example.com",
                    hintStyle: const TextStyle(color: Colors.blueGrey),
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
                    hintText: "1234567890",
                    hintStyle: const TextStyle(color: Colors.blueGrey),
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
                  initialCountryCode: 'EG', // set the default country code
                  onChanged: (phone) {
                    // update the controller value with the full phone number
                    phoneController.text = phone.completeNumber;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
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
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
                    return AlertDialog(
                      title: const Text("Enter Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: otpCodeController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.code),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.grey))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final code = otpCodeController.text.trim();
                              AuthCredential authCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code);
                              User user = (await FirebaseAuth.instance
                                      .signInWithCredential(authCredential))
                                  .user!;
                              // SAVE THE DATA
                              sp.phonNumberUser(user, emailController.text,
                                  nameController.text);
                              //Checking whether the user exists or not.
                              sp.checkUserExists().then((value) async {
                                if (value == true) {
                                  //user exist
                                  await sp
                                      .getUserDataFromFirestore(sp.uid)
                                      .then((value) => sp
                                          .saveDataToSharedPreferences()
                                          .then((value) =>
                                              sp.setSignIn().then((value) {
                                                nextScreenReplace(context,
                                                    const HomeScreen());
                                              })));
                                } else {
                                  //user not exist
                                  sp.saveDataToFirestore().then(
                                        (value) => sp
                                            .saveDataToSharedPreferences()
                                            .then(
                                              (value) =>
                                                  sp.setSignIn().then((value) {
                                                nextScreenReplace(context,
                                                    const HomeScreen());
                                              }),
                                            ),
                                      );
                                }
                              });
                            },
                            child: const Text("Confirm"),
                          ),
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}
