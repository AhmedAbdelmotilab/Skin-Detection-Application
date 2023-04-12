import 'package:blocauth/model/TfliteModel.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:maps_launcher/maps_launcher.dart';

class FirebaseDataScreen extends StatelessWidget {
  const FirebaseDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget backButton = IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 24,
      ),
      onPressed: () => nextScreenReplace(context, const TfliteModel()),
    );
    const Widget title = Text(
      "Doctors",
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: "Times New Roman",
        fontWeight: FontWeight.bold,
      ),
    );
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TfliteModel()),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data =
                        documents[index].data() as Map<String, dynamic>;
                    final String name = data['name'] ?? '';
                    final String phone = data['phone'] ?? '';
                    final String city = data['city'] ?? '';

                    final GeoPoint location = data['location'] as GeoPoint;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Times New Roman",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      Clipboard.setData(
                                          ClipboardData(text: phone));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Phone number copied to clipboard'),
                                        ),
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Phone: ',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Times New Roman",
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: phone,
                                            style: const TextStyle(
                                              fontFamily: "Times New Roman",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ), // Add some space between the text and the icon
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: phone));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Phone number copied to clipboard'),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.copy,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Text(
                                    'City: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Times New Roman",
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    city,
                                    style: const TextStyle(
                                      fontFamily: "Times New Roman",
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8.0),
                                        const Text(
                                          'Address:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Times New Roman",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        Text(
                                          '${data['address']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      final latitude = location.latitude;
                                      final longitude = location.longitude;
                                      MapsLauncher.launchCoordinates(
                                        latitude,
                                        longitude,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.location_on_outlined,
                                      size: 30,
                                      color: Colors.orangeAccent,
                                    ),
                                    label: const Text(
                                      'Location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.pinkAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
