import 'package:bibleproject_greek/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message.notification);
  });

  runApp(MaterialApp(
    theme: ThemeData.dark(),
    title: "BibleProject - Ελληνικά",
    home: HomeScreen(),
  ));
}
