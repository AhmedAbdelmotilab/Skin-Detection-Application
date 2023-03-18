import 'package:blocauth/model/TfliteModel.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps_launcher/maps_launcher.dart';

class FirebaseDataScreen extends StatelessWidget {
  const FirebaseDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Widget backButton = IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 24,
      ),
      onPressed: () => nextScreenReplace(context, const TfliteModel()),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: backButton,
        title: const Text(
          'Find Your Doctor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Expanded(
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
                      final String email = data['email'] ?? '';
                      final GeoPoint location = data['location'] as GeoPoint;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              final latitude = location.latitude;
                              final longitude = location.longitude;
                              MapsLauncher.launchCoordinates(
                                  latitude, longitude);
                            },
                            icon: const Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
