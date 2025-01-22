import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_apps/screens/qr_code_screen.dart';

import 'package:image_picker/image_picker.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // details
  String? email;
  String? name;
  String? phone;
  String? bio;
  String? specialization;
  // default dp
  String image =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  Future<void> _getUser() async {
    user = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
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

      phoneController.text = phone ?? '';
      bioController.text = bio ?? '';
    });
    print(snap.data());
  }

  Future<void> _updateUserProfile() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'phone': phoneController.text,
        'bio': bioController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      _getUser(); // Refresh the data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
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
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.qr_code,
                              color: Colors.white,
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
                          ),
                        ),
                      ),
                      // user name
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

                  // user image
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.teal.shade50,
                          width: 5,
                        ),
                        shape: BoxShape.circle),
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

              const SizedBox(
                height: 20,
              ),

              // user basic info
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                padding: const EdgeInsets.only(left: 20),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // user email
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.red[900],
                            child: const Icon(
                              Icons.mail_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.email ?? 'Email Not Added',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // user phone number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.blue[800],
                            child: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // user bio
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                padding: const EdgeInsets.only(left: 20, top: 20),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.indigo[600],
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: bioController,
                            decoration: const InputDecoration(
                              hintText: 'Bio',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: _updateUserProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // for picking image from device
  Future selectOrTakePhoto(ImageSource imageSource) async {
    XFile? file =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 12);

    if (file != null) {
      var im = await file.readAsBytes();
      // upload image to cloud
      await uploadFile(im, file.name);
      return;
    }

    print('No photo was selected or taken');
  }

  // dialog for option of take photo from
  Future _showSelectionDialog(BuildContext conntext) async {
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

  // upload image
  Future uploadFile(Uint8List img, String fileName) async {
    final destination = 'dp/${user.displayName}-$fileName';
    try {
      final ref = storage.ref(destination);

      UploadTask uploadTask = ref.putData(img);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('image url : $downloadUrl');

      setState(() {
        image = Uri.decodeFull(downloadUrl.toString());
      });

      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profilePhoto': downloadUrl,
      }, SetOptions(merge: true));

      print("uploaded !!!");
    } catch (e) {
      print(e.toString());
      print('error occurred');
    }
  }
}
