// Packages:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Functions:
Future<bool> login({required String email, required String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    return false;
  }
  return true;
}

Future<bool> signup(
    {required String username,
    required String email,
    required String password}) async {
  try {
    var user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseAuth.instance.currentUser?.updateDisplayName(username);
    await FirebaseFirestore.instance.collection('users').doc(username).set({
      'username': username,
      'userDetails': '',
      'userProfilePicture':
          'https://i.pinimg.com/originals/0a/53/c3/0a53c3bbe2f56a1ddac34ea04a26be98.jpg',
      'email': email,
      'phone': '',
      'items': [],
      'likes': [],
      'chats': [],
      'talksTo': {}
    });
  } catch (e) {
    return false;
  }
  return true;
}

Future<bool> signOutUser() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    return false;
  }
  return true;
}
