// Packages:
import 'package:collegehood/components/input.dart';
import 'package:collegehood/components/text.dart';
import 'package:collegehood/utils/auth.dart';
import 'package:collegehood/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widgets:
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '', password = '';
  bool loginButtonPressed = false, signupButtonPressed = false;
  List<String> errorPrompts = ['', '', '', ''];
  String errorMessage = '';
  dynamic subscription;
  bool disconnected = false;
  bool hidePassword = true;

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
    List<String> values = [email, password];
    List<String> prompts = ['', ''];
    values.asMap().forEach((index, value) {
      if (value.trim() == '') {
        isError = true;
        prompts[index] = 'Field is empty!';
      }
    });
    if (email.split('@')[1] != 'modyuniversity.ac.in') {
      isError = true;
      prompts[0] = 'Email does not belong to MU!';
    }
    if (password.length < 3) {
      isError = true;
      prompts[1] = 'Passwords is too short!';
    }
    setState(() {
      errorPrompts = prompts;
    });
    return !isError;
  }

  void handleLogin() async {
    if (!validation()) return;
    Map isLoginSuccessful = await login(email: email, password: password);
    if (isLoginSuccessful['status']) {
      setState(() {
        errorMessage = '';
      });
      Navigator.pushNamed(context, AuthRoutes.landing);
    } else {
      var errorMessage_ =
          (isLoginSuccessful['payload'] as FirebaseAuthException).message ??
              'Unable to login';
      setState(() {
        errorMessage = errorMessage_;
      });
    }
  }

  void onShowPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
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
            pageTitle('Log In', fontSize: 30),
            const SizedBox(
              height: 20.0,
            ),
            input('Email', onChanged: (value) {
              setState(() {
                email = value;
              });
            }),
            const SizedBox(
              height: 7.5,
            ),
            errorText(errorPrompts[0]),
            const SizedBox(
              height: 7.5,
            ),
            input('Password', onChanged: (value) {
              setState(() {
                password = value;
              });
            }, isObscure: hidePassword),
            const SizedBox(
              height: 7.5,
            ),
            errorText(errorPrompts[1]),
            const SizedBox(
              height: 7.5,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: pageSubtitle('Forgot password?'),
            ),
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
              handleLogin();
            }, isPrimary: true),
            const SizedBox(
              height: 10.0,
            ),
            errorText(errorMessage),
            const SizedBox(
              height: 100.0,
            ),
            pageSubtitle("Don't have an account?"),
            const SizedBox(
              height: 20.0,
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
              Navigator.pushNamed(context, PublicRoutes.signup);
            }),
          ],
        ),
      ),
    );
  }
}
