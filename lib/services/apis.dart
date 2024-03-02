import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';

import '../models/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static late ChatUser me;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static User get currentUser => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await fireStore.collection('users').doc(currentUser.uid).get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    (await fireStore
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        {
          await (createUser().then((value) => getSelfInfo()));
        }
      }
      ;
    }));
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final user = ChatUser(
      id: currentUser.uid,
      name: currentUser.displayName.toString(),
      email: currentUser.email.toString(),
      about: "Hey, I'm using G!",
      image: currentUser.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return (await fireStore
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toJson()));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore
        .collection("users")
        .where('id', isNotEqualTo: currentUser.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await fireStore.collection('users').doc(currentUser.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref =
        fireStorage.ref().child('profile_pictures/${currentUser.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await fireStore
        .collection('users')
        .doc(currentUser.uid)
        .update({'image': me.image});
  }

  static String getConversationID(String id) =>
      currentUser.uid.hashCode <= id.hashCode
          ? '${currentUser.uid}_$id'
          : '${id}_${currentUser.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return fireStore
        .collection("chats/${getConversationID(user.id)}/messages/")
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser user, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: user.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: currentUser.uid,
        sent: time);

    final ref =
        fireStore.collection('chats/${getConversationID(user.id)}/messages');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    fireStore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
