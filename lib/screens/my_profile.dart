import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_apps/screens/qr_code_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'setting.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // User details
  String? email;
  String? name;
  String? phone;
  String? bio;
  String? specialization;
  String image =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'; // Default profile picture

  Future<void> _getUser() async {
    user = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users') // Unified collection for all users
        .doc(user.uid)
        .get();

    setState(() {
      var snapshot = snap.data() as Map<String, dynamic>;
      email = snapshot['email'];
      name = snapshot['name'];
      phone = snapshot['phone'];
      bio = snapshot['bio'];
      image = snapshot['profilePhoto'] ?? image;
      specialization = snapshot['specialization'];
    });
    print(snap.data());
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.5],
                            colors: [
                              Colors.indigo,
                              Colors.indigoAccent,
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 5,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, right: 7),
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserSettings(),
                                    ),
                                  ).then((value) {
                                    _getUser();
                                    setState(() {});
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QRCodeScreen(
                                        userInfo: {
                                          'name': name ?? 'Name Not Added',
                                          'email': email ?? 'Email Not Added',
                                          'phone': phone ?? 'Phone Not Added',
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 6,
                        padding: const EdgeInsets.only(top: 75),
                        child: Text(
                          name ?? 'Name Not Added',
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(specialization == null ? '' : '($specialization)'),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.teal.shade50,
                        width: 5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        _showSelectionDialog(context);
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(image),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoCard('Email', email ?? 'Email Not Added',
                  Colors.red[900]!, Icons.mail_rounded),
              const SizedBox(height: 20),
              _buildInfoCard('Phone', phone ?? 'Phone Not Added',
                  Colors.blue[800]!, Icons.phone),
              const SizedBox(height: 20),
              _buildBioCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[50],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo[600]!,
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'Bio',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            bio ?? 'Not Added',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Future _showSelectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('From gallery'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text('Take a photo'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    XFile? file =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 12);

    if (file != null) {
      var im = await file.readAsBytes();
      await uploadFile(im, file.name);
    }
  }

  Future uploadFile(Uint8List img, String fileName) async {
    final destination = 'dp/${user.displayName}-$fileName';
    try {
      final ref = storage.ref(destination);
      UploadTask uploadTask = ref.putData(img);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        image = Uri.decodeFull(downloadUrl);
      });
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profilePhoto': downloadUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }
}
