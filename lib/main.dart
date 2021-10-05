// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hello_fire/green_page.dart';
import 'package:hello_fire/red_page.dart';

void main() async {
  // For firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
      routes: {
        "red": (_) => const RedPage(),
        "green": (_) => const GreenPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('------------>> Foreground');
        print(message.notification!.body);
        print(message.notification!.title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Text(
            "Hello Push Notification",
            style: TextStyle(
              fontSize: 34,
            ),
          ),
        ),
      ),
    );
  }
}
