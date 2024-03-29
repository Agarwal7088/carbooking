import 'package:cab_booking_user/screens/otpscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPhoneNoLogin extends StatefulWidget {
  UserPhoneNoLogin({Key? key});

  @override
  State<UserPhoneNoLogin> createState() => _UserPhoneNoLoginState();
}

class _UserPhoneNoLoginState extends State<UserPhoneNoLogin> {
  final TextEditingController _contactNumberController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool isLoading = false;
  String? _errorText;

  // Function to send OTP to the user's phone number
  Future<void> _sendOTP() async {
    setState(() {
      isLoading = true;
    });

    String phoneNumber = '+91${_contactNumberController.text.trim()}';
    if (_contactNumberController.text.trim().length != 10) {
      setState(() {
        _errorText = 'Phone number should be exactly 10 digits.';
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        _errorText = null;
      });
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _navigateToUserOtp();
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone number verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            isLoading = false;
          });
          _navigateToUserOtp();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            isLoading = false;
          });
        },
      );
    } catch (e) {
      print('Error sending OTP: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to navigate to the UserOtp page
  void _navigateToUserOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserOtp(verificationId: _verificationId.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'images/logo.png',
                height: screenHeight * 0.22,
              ),
              // SizedBox(
              //   height: screenHeight * 0.1,
              // ),
              Text(
                " User",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900),
              ),
              Text(
                " Login",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  controller: _contactNumberController,
                  cursorColor: Colors.brown.shade900,
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    labelText: 'Enter Phone No',
                    errorText: _errorText, // Show error text if not null
                    labelStyle: TextStyle(color: Colors.brown.shade900),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(width: 3, color: Colors.brown.shade900),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.brown.shade900,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      backgroundColor: Colors.brown.shade900,
                      shape: const StadiumBorder(),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.brown.shade900,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login as Admin?"),
                  TextButton(
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => AdminPhoneNoLogin()),
                      // );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
