// Packages:
import 'package:collegehood/components/text.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets:
var option = (data, asset, {void Function()? onTap}) => InkWell(
    onTap: onTap,
    child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: SizedBox(
            height: 150,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(asset), fit: BoxFit.cover),
                ),
                child: Center(
                    child: Text(data,
                        style: GoogleFonts.montserrat(
                            height: data == '' ? 0 : 1,
                            textStyle: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            )))),
              ),
            ))));

class AuthLanding extends StatelessWidget {
  const AuthLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pageTitle('What are you looking for?', fontSize: 20),
            const SizedBox(
              height: 7.5,
            ),
            option('ReBuy', 'assets/images/rebuyoptionbackground.jpeg',
                onTap: () {
              Navigator.pushNamed(context, AuthRoutes.rebuyExplore);
            }),
            option('Events', 'assets/images/eventsoptionbackground.jpeg',
                onTap: () {
              Navigator.pushNamed(context, AuthRoutes.eventsAll);
            }),
          ]),
    );
  }
}
