// ignore_for_file: file_names, unused_local_variable, use_build_context_synchronously

import 'dart:io';
import 'package:blocauth/model/doctors.dart';
import 'package:blocauth/screens/home_screen.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  late File _image;
  late List _results;
  bool imageSelect = false;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt"))!;
    // ignore: avoid_print
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 4,
      threshold: 0.0909,
      imageMean: 0,
      imageStd: 255,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget backButton = IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 24,
      ),
      onPressed: () => nextScreenReplace(context, const HomeScreen()),
    );

    const Widget title = Text(
      "Image Classification",
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
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Scrollbar(
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (imageSelect)
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.orangeAccent, // Set the background color
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
                        margin: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Image.file(_image),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 250,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color:
                              Colors.orangeAccent, // Set the background color
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.orangeAccent, Colors.pinkAccent],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, size: 64, color: Colors.black),
                            SizedBox(height: 16),
                            Text(
                              "No image selected",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Times New Roman",
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          if (imageSelect)
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final result = _results[index];
                                final label = result['label'];
                                final confidence = result['confidence'];
                                final isAhmed = label == 'Eczema';
                                final labelText =
                                    '$label - ${confidence.toStringAsFixed(2)}';
                                return Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minWidth: double.infinity),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.grey.withOpacity(0.5),
                                              Colors.pinkAccent.shade100,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              "Disease Prediction",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Arial",
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            Text(
                                              labelText,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Times New Roman",
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    if (isAhmed)
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                        child: Container(
                                          width: 400,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.grey.withOpacity(0.5),
                                                Colors.pinkAccent.shade100,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Visibility(
                      visible: imageSelect == true,
                      child: ElevatedButton(
                        onPressed: () {
                          nextScreenReplace(
                              context, const FirebaseDataScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 252, 172, 69),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person, color: Colors.black87),
                            SizedBox(width: 10),
                            Text(
                              "Show doctors",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Times New Roman",
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              child: const Icon(Icons.image),
              label: "Pick Image",
              onTap: pickImage,
            ),
            SpeedDialChild(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              child: const Icon(Icons.camera),
              label: 'Take Image',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.7),
                              Colors.pink.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 300, // Adjust the width as needed
                          height: 300, // Adjust the height as needed
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/camera.png',
                                  width: 400, // Adjust the width as needed
                                  height: 400, // Adjust the height as needed
                                  fit: BoxFit.fill, // Adjust the fit as needed
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    take();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
    final confirmed = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Image?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Would you like to upload this image to our database in order to improve our app?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text('Upload'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      // User confirmed upload, proceed with image classification and upload
      File image = File(pickedFile.path);
      imageClassification(image);
      final Reference storageRef = FirebaseStorage.instance
          .ref('blocauth-5963f.appspot.com')
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final TaskSnapshot uploadTask =
          await storageRef.putFile(File(pickedFile.path));
      // Show snackbar after upload is complete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('The image uploaded successfully. Thank you for your help.'),
        ),
      );
    }
  }

  Future take() async {
    final ImagePicker take = ImagePicker();
    final XFile? pickedFile = await take.pickImage(
      source: ImageSource.camera,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
    final confirmed = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Image?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times New Roman",
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Would you like to upload this image to our database in order to improve our app?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Times New Roman",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) {
      // User confirmed upload, proceed with image classification and upload
      File image = File(pickedFile.path);
      imageClassification(image);
      final Reference storageRef = FirebaseStorage.instance
          .ref('blocauth-5963f.appspot.com')
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final TaskSnapshot uploadTask =
          await storageRef.putFile(File(pickedFile.path));
      // Show snackbar after upload is complete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('The image uploaded successfully. Thank you for your help.'),
        ),
      );
    }
  }
}
