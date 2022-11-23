// Packages:
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Functions:
var pageTitle =
    (String data, {double? fontSize, FontWeight? fontWeight}) => Text(data,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
          fontSize: fontSize ?? 30,
          color: Colors.white,
          fontWeight: fontWeight ?? FontWeight.w800,
        )));

var pageSubtitle =
    (String data, {double? fontSize, FontWeight? fontWeight}) => Text(data,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
          fontSize: fontSize ?? 14,
          color: Colors.grey[400],
          fontWeight: fontWeight ?? FontWeight.normal,
        )));

var errorText =
    (String data, {double? fontSize, FontWeight? fontWeight}) => Text(data,
        style: GoogleFonts.montserrat(
            height: data == '' ? 0 : 1,
            textStyle: TextStyle(
              fontSize: fontSize ?? 14,
              color: Colors.red[300],
              fontWeight: fontWeight ?? FontWeight.normal,
            )));
