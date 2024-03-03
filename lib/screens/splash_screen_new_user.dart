import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitter_messaging_app/constants/assets.dart';

import '../main.dart';

//splash screen
class SplashScreenNewUser extends StatefulWidget {
  const SplashScreenNewUser({super.key});

  @override
  State<SplashScreenNewUser> createState() => _SplashScreenNewUserState();
}

class _SplashScreenNewUserState extends State<SplashScreenNewUser> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 0),
      () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            statusBarColor: Colors.transparent));

        // if (APIs.auth.currentUser != null) {
        //   log('\nUser: ${APIs.auth.currentUser}');
        //   // context.pushReplacement('/');
        // } else {
        //   // context.pushReplacement('/loginScreen');
        // }
      },
    );
  }

  // @override
  // void dispose() {
  //   SystemChrome.se
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset(Assets.resourceGarudaMessagingApp)),

        //google login button
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text('MADE IN INDIA WITH ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.white70, letterSpacing: .5))),
      ]),
    );
  }
}
