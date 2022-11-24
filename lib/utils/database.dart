// Packages:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

Map<String, dynamic> defaultItem = {
  'itemID': '123',
  'photoURL':
      'https://images.pexels.com/photos/1749057/pexels-photo-1749057.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  'itemName': 'Item Not Found',
  'itemDetail': 'Item could not be found. Maybe it has been removed?',
  'itemPrice': '0',
  'itemDescription': "Item could not be found.",
  'username': 'anon',
  'isSold': false,
};

Map<String, dynamic> defaultUser = {
  'username': 'anon',
  'userDetails': 'An anonymous person - just a template.',
  'userProfilePicture':
      'https://i.pinimg.com/originals/0a/53/c3/0a53c3bbe2f56a1ddac34ea04a26be98.jpg',
  'email': 'anon@anon.com',
  'phone': '0000000000',
  'items': [],
  'likes': [],
  'chats': [],
  'talksTo': {}
};

Map<String, String> defaultEvent = {
  'eventID': '123',
  'title': 'Event',
  'description': 'This is an event',
  'picture':
      'https://images.pexels.com/photos/1749057/pexels-photo-1749057.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
};

// Functions:
Future<Map<String, dynamic>> getItem(String itemID) async {
  try {
    var item =
        (await FirebaseFirestore.instance.collection('items').doc(itemID).get())
            .data();
    if (item == null) {
      return defaultItem;
    } else {
      return item;
    }
  } catch (e) {
    return defaultItem;
  }
}

Future<Map<String, dynamic>> getUserDetails(String username) async {
  try {
    var user = (await FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .get())
        .data();
    if (user == null) {
      return defaultUser;
    } else {
      return user;
    }
  } catch (e) {
    return defaultUser;
  }
}

saveUserDetails(
    {required String username,
    required String email,
    required String phone,
    required String userDetails}) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .update({'email': email, 'phone': phone, 'userDetails': userDetails});
  } catch (e) {
    return;
  }
}

Future<Iterable<Map<String, dynamic>>> loadRebuyItems() async {
  try {
    var docs = (await FirebaseFirestore.instance
            .collection('items')
            .where('isSold', isEqualTo: false)
            .limit(50)
            .get())
        .docs;
    return docs.map((doc) => doc.data());
  } catch (e) {
    return [];
  }
}

likeItem({required String itemID, required String username}) async {
  try {
    await FirebaseFirestore.instance.collection('items').doc(itemID).update({
      'likedBy': FieldValue.arrayUnion([username])
    });
    await FirebaseFirestore.instance.collection('users').doc(username).update({
      'likes': FieldValue.arrayUnion([itemID])
    });
  } catch (e) {
    return;
  }
}

unlikeItem({required String itemID, required String username}) async {
  try {
    await FirebaseFirestore.instance.collection('items').doc(itemID).update({
      'likedBy': FieldValue.arrayRemove([username])
    });
    await FirebaseFirestore.instance.collection('users').doc(username).update({
      'likes': FieldValue.arrayUnion([itemID])
    });
  } catch (e) {
    return;
  }
}

saveNewItem(
    {required String itemID,
    required String itemDescription,
    required String itemDetail,
    required String itemName,
    required String itemPrice,
    required String username,
    required String uploadedPicture}) async {
  FirebaseFirestore.instance.collection('items').doc(itemID).set({
    'isSold': false,
    'itemDescription': itemDescription,
    'itemDetail': itemDetail,
    'itemID': itemID,
    'itemName': itemName,
    'itemPrice': itemPrice,
    'likedBy': [],
    'photoURL': uploadedPicture ??
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z2lmdHxlbnwwfHwwfHw%3D&w=1000&q=80',
    'username': username
  });
  FirebaseFirestore.instance.collection('users').doc(username).update({
    'items': FieldValue.arrayUnion([itemID])
  });
}

Future<List<Map<String, dynamic>>> getLikedItems(String username) async {
  try {
    var user = (await FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .get())
        .data();
    List<Map<String, dynamic>> items = [];
    for (String likedItemID in user!['likes']) {
      var item = (await FirebaseFirestore.instance
              .collection('items')
              .doc(likedItemID)
              .get())
          .data();
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  } catch (e) {
    return [];
  }
}

getUsersItems(String username) async {
  try {
    var docs = (await FirebaseFirestore.instance
            .collection('items')
            .where('username', isEqualTo: username)
            .limit(50)
            .get())
        .docs;
    var items = docs.map((doc) => doc.data()).toList();
    return items;
  } catch (e) {
    return [];
  }
}

deleteItem({required String itemID, required String username}) async {
  try {
    await FirebaseFirestore.instance.collection('items').doc(itemID).delete();
    await FirebaseFirestore.instance.collection('users').doc(username).update({
      'items': FieldValue.arrayRemove([itemID])
    });
  } catch (e) {}
}

// Events:
Future<Map<String, dynamic>> getEvent(String eventID) async {
  try {
    var event = (await FirebaseFirestore.instance
            .collection('events')
            .doc(eventID)
            .get())
        .data();
    if (event == null) {
      return defaultEvent;
    } else {
      return event;
    }
  } catch (e) {
    return defaultEvent;
  }
}

Future<Iterable<Map<String, dynamic>>> loadEvents() async {
  try {
    var docs =
        (await FirebaseFirestore.instance.collection('events').limit(50).get())
            .docs;
    return docs.map((doc) => doc.data());
  } catch (e) {
    return [];
  }
}

saveNewEvent(
    {required String eventID,
    required String title,
    required String description,
    required String picture}) async {
  FirebaseFirestore.instance.collection('events').doc(eventID).set({
    'eventID': eventID,
    'title': title,
    'description': description,
    'picture': picture ??
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z2lmdHxlbnwwfHwwfHw%3D&w=1000&q=80',
  });
}

// Chat:
Future<List<Map<String, dynamic>>> loadUsersChats(String username) async {
  try {
    List<Map<String, dynamic>> chats = [];
    var user = await getUserDetails(username);
    var chatIDs = user['chats'];
    for (var chatID in chatIDs) {
      var snapshot =
          await FirebaseDatabase.instance.ref().child('chats/$chatID').get();
      if (snapshot.exists) {
        var chatDetails = snapshot.value as dynamic;
        var otherUsername = chatDetails['p1'] == username
            ? chatDetails['p2']
            : chatDetails['p1'];
        var otherUserDetails = await getUserDetails(otherUsername);
        chats.add({
          ...chatDetails,
          'chatID': chatID,
          'username': otherUsername,
          'picture': otherUserDetails['userProfilePicture']
        });
      }
    }
    return chats;
  } catch (e) {
    return [];
  }
}

Future<List<Map<String, dynamic>>> loadConversationFromChatID(
    String chatID) async {
  try {
    var snapshot = (await FirebaseDatabase.instance
            .ref()
            .child('conversations/$chatID')
            .limitToLast(100)
            .get())
        .value;
    if (snapshot != null) {
      var messages = (snapshot as Map<dynamic, dynamic>).entries.map((entry) {
        return {
          'name': entry.value['name'],
          'message': entry.value['message'],
          'timestamp': entry.value['timestamp']
        };
      }).toList();
      return messages;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<List<Map<String, dynamic>>> loadConversationFromUsername(
    String me, String them) async {
  var meUser = await getUserDetails(me);
  final chatID = UniqueKey().hashCode.toString();
  if (meUser['talksTo'][them] != null) {
    var chats = await loadConversationFromChatID(meUser['talksTo'][them]);
    return chats;
  } else {
    // New conversation
    await FirebaseFirestore.instance.collection('users').doc(me).update({
      'talksTo.$them': chatID,
      'chats': FieldValue.arrayUnion([chatID])
    });
    await FirebaseFirestore.instance.collection('users').doc(them).update({
      'talksTo.$me': chatID,
      'chats': FieldValue.arrayUnion([chatID])
    });
    String message = 'Hello! I was interested in the item you\'re selling!';
    await FirebaseDatabase.instance.ref().child('chats/$chatID').set({
      'lastMessage': message,
      'p1': me,
      'p2': them,
      'sentBy': me,
      'timestamp': Timestamp.now().millisecondsSinceEpoch.toString()
    });
    await FirebaseDatabase.instance
        .ref()
        .child('conversations/$chatID')
        .push()
        .set({
      'message': message,
      'name': me,
      'timestamp': Timestamp.now().millisecondsSinceEpoch.toString()
    });
  }
  return [];
}

sendMessage(String from, String to, String message) async {
  var fromUser = await getUserDetails(from);
  var chatID = fromUser['talksTo'][to];
  await FirebaseDatabase.instance
      .ref()
      .child('conversations/$chatID')
      .push()
      .set({
    'message': message,
    'name': from,
    'timestamp': Timestamp.now().millisecondsSinceEpoch.toString()
  });
  await FirebaseDatabase.instance.ref().child('chats/$chatID').set({
    'lastMessage': message,
    'p1': from,
    'p2': to,
    'sentBy': from,
    'timestamp': Timestamp.now().millisecondsSinceEpoch.toString()
  });
}

sendMessageCID(String from, String chatID, String message) async {
  await FirebaseDatabase.instance
      .ref()
      .child('conversations/$chatID')
      .push()
      .set({
    'message': message,
    'name': from,
    'timestamp': Timestamp.now().millisecondsSinceEpoch.toString()
  });
  await FirebaseDatabase.instance.ref().child('chats/$chatID').update({
    'lastMessage': message,
    'p1': from,
    'sentBy': from,
    'timestamp': Timestamp.now().millisecondsSinceEpoch.toString()
  });
}
