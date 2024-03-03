import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_messaging_app/constants/assets.dart';
import 'package:twitter_messaging_app/services/riverpod.dart';

import '../helper/dialogs.dart';
import '../services/apis.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doesUserExist = ref.watch(userExistProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => false,
          loading: () => false,
        );

    handleUserBtnClick(BuildContext context) {
      //for showing progress bar
      Dialogs.showProgressBar(context);

      _signInWithGoogle(context).then((user) async {
        //for hiding progress bar
        Navigator.pop(context);

        if (user != null) {
          log('\nUser: ${user.user}');
          log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

          if (doesUserExist != null) {
            // context.go('/');
          } else {
            await APIs.createUser().then((value) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            });
          }
        }
      });
    }

    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(Assets.resourceGarudaMessagingApp)
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 1000))
            .shimmer(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 1000)),
        ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: () {
              handleUserBtnClick(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.login,
                    color: Colors.red,
                    size: 30,
                  ),
                  const Gap(20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Signin ",
                          style: GoogleFonts.lato(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                        TextSpan(
                          text: "With ",
                          style: GoogleFonts.lato(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                        TextSpan(
                          text: "Google",
                          style: GoogleFonts.lato(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .show(duration: const Duration(milliseconds: 600))
                .shimmer(
                  delay: const Duration(milliseconds: 1000),
                ))
      ],
    )));
  }
}

Future<UserCredential?> _signInWithGoogle(BuildContext context) async {
  try {
    await InternetAddress.lookup('google.com');

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await APIs.auth.signInWithCredential(credential);
  } catch (e) {
    Dialogs.showSnackBar(context, 'Something Went Wrong (Check Internet!)');
    log('\n_signInWithGoogle: $e');
    return null;
  }
}

// final GoogleSignIn _googleSignIn = GoogleSignIn();
//
// void signOut() async {
//   await APIs.auth.signOut();
//   await _googleSignIn.signOut();
// }
