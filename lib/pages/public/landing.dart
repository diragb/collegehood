// Packages:
import 'package:collegehood/components/input.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Components:
RichText title = RichText(
  text: TextSpan(
    style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
      fontSize: 25,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    )),
    children: const <TextSpan>[
      TextSpan(text: 'Welcome To College'),
      TextSpan(text: 'Hood', style: TextStyle(fontWeight: FontWeight.w700)),
    ],
  ),
);

// Widgets:
class PublicLanding extends StatefulWidget {
  const PublicLanding({super.key});

  @override
  _PublicLanding createState() => _PublicLanding();
}

class _PublicLanding extends State<PublicLanding> {
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushNamed(context, AuthRoutes.landing);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/publiclandingbackground.jpeg'),
              fit: BoxFit.cover),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            const SizedBox(
              height: 25.0,
            ),
            button('Get Started', buttonPressed: buttonPressed,
                onTap: () async {
              setState(() {
                buttonPressed = true;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {
                buttonPressed = false;
              });
              Navigator.pushNamed(context, PublicRoutes.login);
            }),
          ],
        )),
      ),
    ));
  }
}
