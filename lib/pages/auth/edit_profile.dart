// Packages:
import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/database.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets:
var label = (String data) => Text(data,
    style: GoogleFonts.montserrat(
        textStyle: TextStyle(
      fontSize: 16,
      color: Colors.grey[700],
      fontWeight: FontWeight.w400,
    )));

var value = (String data) => Text(data,
    style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    )));

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool buttonPressed = false;
  String username = '',
      email = '',
      phone = '',
      userDetails = '',
      userProfilePicture = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          setState(() {
            username = user.displayName ?? '';
          });
          loadProfile();
        } else {
          Navigator.pushNamed(context, PublicRoutes.login);
        }
      });
    });
  }

  loadProfile() async {
    Map<String, dynamic> user = await getUserDetails(username);
    print(username);
    print(user);
    setState(() {
      email = user['email'];
      phone = user['phone'];
      userDetails = user['userDetails'];
      userProfilePicture = user['userProfilePicture'];
    });
  }

  saveDetails() async {
    setState(() {
      buttonPressed = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      buttonPressed = false;
    });
    saveUserDetails(
        email: email,
        phone: phone,
        userDetails: userDetails,
        username: username);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                profileTopBar(context, isEdit: true),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    width: 175,
                    height: 175,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(userProfilePicture),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(82.5))),
                const SizedBox(
                  height: 15,
                ),
                input('Details', initialValue: userDetails, onChanged: (value) {
                  setState(() {
                    userDetails = value;
                  });
                }),
                const SizedBox(
                  height: 15,
                ),
                input('Email', initialValue: email, onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                }),
                const SizedBox(
                  height: 15,
                ),
                input('Phone', initialValue: phone, onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                }),
                const SizedBox(
                  height: 20,
                ),
                authButton('Save',
                    buttonPressed: buttonPressed,
                    onTap: saveDetails,
                    isPrimary: true),
                const SizedBox(
                  height: 15,
                ),
                authButton('Cancel', buttonPressed: buttonPressed, onTap: () {
                  Navigator.pop(context);
                })
              ])),
        ));
  }
}
