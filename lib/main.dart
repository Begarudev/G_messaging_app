import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_messaging_app/firebase_options.dart';
import 'package:twitter_messaging_app/screens/splash_screen.dart';
import 'package:twitter_messaging_app/services/riverpod.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final isSignedIn = await GoogleSignIn().isSignedIn();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.transparent,
  //     statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF0E332D),
        ),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: ref.watch(isGoogleSignedIn).when(
            data: (data) => data != null ? HomeScreen() : const LoginScreen(),
            error: (error, stackTrace) {
              // showDialog(
              //   context: context,
              //   builder: (context) => Center(
              //     child: Text("Error: $error"),
              //   ),
              // );
              return Text("Error: $error");
            },
            loading: () => const SplashScreen(),
          ),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}
