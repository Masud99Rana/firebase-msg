// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hello_fire/green_page.dart';
import 'package:hello_fire/red_page.dart';

// Receive messages when app is in background
// Here this function is top level. No scope should not restrict it
Future<void> backgroundHandler(RemoteMessage message) async {
  print('------------>> backgroundHandler');
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  // Initialize Fireabase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // It should be top level funtion
  // It should not in any class
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

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

    // Gives you the message on which user taps
    // and it opened the app from terminated state ( like app was closed )
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        print('------------>> getInitialMessage');
        print(routeFromMessage);
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    // Receive messages When the app is in Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('------------>> Foreground');
        print(message.notification!.body);
        print(message.notification!.title);
      }
    });

    // Receive messages When the app is in the background but opened and user taps
    // on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      print('------------>> onMessageOpenedApp');
      print(routeFromMessage);
      Navigator.of(context).pushNamed(routeFromMessage);
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
