import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_apps/screens/sign_in.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  @override
  void dispose() {
    _displayName.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: _signUp(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUp() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                'Sign up',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTextFormField(
              controller: _displayName,
              hintText: 'Name',
              focusNode: f1,
              nextFocusNode: f2,
              validator: (value) => value!.isEmpty ? 'Please enter your Name' : null,
            ),
            const SizedBox(height: 25),
            _buildTextFormField(
              controller: _emailController,
              hintText: 'Email',
              focusNode: f2,
              nextFocusNode: f3,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Email';
                } else if (!emailValidate(value)) {
                  return 'Please enter a valid Email';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            _buildTextFormField(
              controller: _passwordController,
              hintText: 'Password',
              focusNode: f3,
              nextFocusNode: f4,
              isObscured: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            _buildTextFormField(
              controller: _passwordConfirmController,
              hintText: 'Confirm Password',
              focusNode: f4,
              isObscured: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm your Password';
                } else if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildSignUpButton(),
            const SizedBox(height: 20),
            _buildSignInOption(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    bool isObscured = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscured,
      style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w800),
      textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (value) {
        focusNode.unfocus();
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
        filled: true,
        fillColor: Colors.grey[350],
        hintText: hintText,
        hintStyle: GoogleFonts.lato(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w800),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            showLoaderDialog(context);
            await _registerAccount();
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.indigo[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Text(
          "Sign Up",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: () => _pushPage(context, const SignIn()),
          child: Text(
            'Sign in',
            style: GoogleFonts.lato(
              fontSize: 15,
              color: Colors.indigo[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: const Text("Loading...")),
            ],
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Error!",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: GoogleFonts.lato(),
      ),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool emailValidate(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
        .hasMatch(email);
  }

  Future<void> _registerAccount() async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = credential.user;
      if (user != null) {
        await user.updateDisplayName(_displayName.text);
        await user.sendEmailVerification();

        String name = _displayName.text;
        String accountType = 'patient';  // Set account type to patient only

        Map<String, dynamic> userData = {
          'name': name,
          'type': accountType,
          'email': user.email,
        };

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData);

        FirebaseFirestore.instance
            .collection(accountType)
            .doc(user.uid)
            .set(userData);

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      }
    } catch (error) {
      String errorMessage = 'Registration failed. Please try again.';
      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'The email address is already in use.';
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'The password provided is too weak.';
      }

      Navigator.pop(context); // Close the loader dialog
      showAlertDialog(context, errorMessage);
    }
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
