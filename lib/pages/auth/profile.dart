// Packages:
import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/topbar.dart';
import 'package:collegehood/utils/auth.dart';
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

var value = (String data) => Container(
    width: 200,
    child: Text(
      data,
      style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      )),
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
    ));

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool buttonPressed = false, listingsButtonPressed = false;
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
    setState(() {
      email = user['email'] ?? '';
      phone = user['phone'] ?? '';
      userDetails = user['userDetails'] ?? '';
      userProfilePicture = user['userProfilePicture'] ?? '';
    });
  }

  signOut() async {
    setState(() {
      buttonPressed = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      buttonPressed = false;
    });
    signOutUser();
    Navigator.pushNamedAndRemoveUntil(
        context, PublicRoutes.landing, (route) => false);
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
                profileTopBar(context),
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
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [label('Username'), value(username)]),
                const SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [label('Details'), value(userDetails)]),
                const SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [label('Email'), value(email)]),
                const SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [label('Phone'), value(phone)]),
                const SizedBox(
                  height: 20,
                ),
                authButton('My Listings',
                    isPrimary: true,
                    buttonPressed: listingsButtonPressed, onTap: () async {
                  setState(() {
                    listingsButtonPressed = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    listingsButtonPressed = false;
                  });
                  signOutUser();
                  Navigator.pushNamed(context, AuthRoutes.rebuyMyListings);
                }),
                const SizedBox(
                  height: 10,
                ),
                authButton('Sign Out',
                    buttonPressed: buttonPressed, onTap: signOut)
              ])),
        ));
  }
}
