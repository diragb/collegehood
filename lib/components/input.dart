import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

dynamic controllerDecider(String? iv) {
  if (iv != null) {
    return TextEditingController()..text = iv;
  } else {
    return null;
  }
}

var input = (String labelText,
        {void Function(String)? onChanged,
        void Function(String)? onFieldSubmitted,
        bool? isObscure,
        bool? isMultiline,
        String? initialValue}) =>
    TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      controller: controllerDecider(initialValue),
      // initialValue: initialValue,
      keyboardType:
          (isMultiline ?? false) ? TextInputType.multiline : TextInputType.text,
      minLines: 1,
      maxLines: (isMultiline ?? false) ? 5 : 1,
      obscureText: isObscure ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.white,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 5, color: Colors.white),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onChanged: onChanged,
    );

var button = (String text,
        {void Function()? onTap, required bool buttonPressed}) =>
    InkWell(
        onTap: onTap,
        child: Container(
          width: 200,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: buttonPressed ? Colors.blue[300] : Colors.blue,
              borderRadius: BorderRadius.circular(10)),
          child: Text(text,
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ))),
        ));

var authButton = (String text,
        {void Function()? onTap,
        required bool buttonPressed,
        bool? isPrimary}) =>
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: InkWell(
            onTap: onTap,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: (isPrimary ?? false)
                      ? (buttonPressed ? Colors.blue[300] : Colors.blue)
                      : buttonPressed
                          ? Colors.blue[100]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(text,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                    fontSize: 20,
                    color: (isPrimary ?? false) ? Colors.white : Colors.black,
                    fontWeight: (isPrimary ?? false)
                        ? FontWeight.normal
                        : FontWeight.w500,
                  ))),
            )));
