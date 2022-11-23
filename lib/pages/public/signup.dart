// Packages:
import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/utils/auth.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widgets:
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String username = '', email = '', password = '', repassword = '';
  bool loginButtonPressed = false, signupButtonPressed = false;
  List<String> errorPrompts = ['', '', '', ''];
  String errorMessage = '';

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

  bool validation() {
    bool isError = false;
    List<String> values = [username, email, password, repassword];
    List<String> prompts = ['', '', '', ''];
    values.asMap().forEach((index, value) {
      if (value.trim() == '') {
        isError = true;
        prompts[index] = 'Field is empty!';
      }
    });
    if (password.length < 3) {
      isError = true;
      prompts[2] = 'Passwords is too short!';
    }
    if (password != repassword) {
      isError = true;
      prompts[3] = 'Passwords are not the same!';
    }
    setState(() {
      errorPrompts = prompts;
    });
    return !isError;
  }

  void handleSignup() async {
    if (!validation()) return;
    Map isSignupSuccessful =
        await signup(username: username, email: email, password: password);
    if (isSignupSuccessful['status']) {
      setState(() {
        errorMessage = '';
      });
      Navigator.pushNamed(context, AuthRoutes.landing);
    } else {
      var errorMessage_ =
          (isSignupSuccessful['payload'] as FirebaseAuthException).message ??
              'Unable to sign up';
      setState(() {
        errorMessage = errorMessage_;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pageTitle('Create Account', fontSize: 30),
            const SizedBox(
              height: 20.0,
            ),
            input('Username', onChanged: (value) {
              setState(() {
                username = value;
              });
            }),
            const SizedBox(
              height: 7.5,
            ),
            errorText(errorPrompts[0]),
            const SizedBox(
              height: 7.5,
            ),
            input('Email', onChanged: (value) {
              setState(() {
                email = value;
              });
            }),
            const SizedBox(
              height: 7.5,
            ),
            errorText(errorPrompts[1]),
            const SizedBox(
              height: 7.5,
            ),
            input('Password', onChanged: (value) {
              setState(() {
                password = value;
              });
            }, isObscure: true),
            const SizedBox(
              height: 7.5,
            ),
            errorText(errorPrompts[2]),
            const SizedBox(
              height: 7.5,
            ),
            input('Retype Password', onChanged: (value) {
              setState(() {
                repassword = value;
              });
            }, isObscure: true),
            const SizedBox(
              height: 7.5,
            ),
            errorText(errorPrompts[3]),
            const SizedBox(
              height: 7.5,
            ),
            authButton('Sign Up', buttonPressed: signupButtonPressed,
                onTap: () async {
              setState(() {
                signupButtonPressed = true;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {
                signupButtonPressed = false;
              });
              handleSignup();
            }, isPrimary: true),
            const SizedBox(
              height: 10.0,
            ),
            errorText(errorMessage),
            const SizedBox(
              height: 80.0,
            ),
            pageSubtitle('Already have an account?'),
            const SizedBox(
              height: 20.0,
            ),
            authButton('Login', buttonPressed: loginButtonPressed,
                onTap: () async {
              setState(() {
                loginButtonPressed = true;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {
                loginButtonPressed = false;
              });
              Navigator.pushNamed(context, PublicRoutes.login);
            }),
          ],
        ),
      ),
    );
  }
}
