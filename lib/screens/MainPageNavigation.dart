import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_apps/screens/user/main_page_patient.dart';

class MainPageNavigation extends StatefulWidget {
  const MainPageNavigation({super.key});

  @override
  State<MainPageNavigation> createState() => _MainPageNavigationState();
}

class _MainPageNavigationState extends State<MainPageNavigation> {
  bool _isLoading = true;
  void _setUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    //var basicInfo = snap.data() as Map<String, dynamic>;

   
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : const MainPagePatient();
  }
}
