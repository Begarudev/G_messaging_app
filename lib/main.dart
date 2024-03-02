import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_messaging_app/firebase_options.dart';
import 'package:twitter_messaging_app/screens/ProfileScreen.dart';
import 'package:twitter_messaging_app/screens/settings_screen.dart';
import 'package:twitter_messaging_app/screens/splash_screen.dart';
import 'package:twitter_messaging_app/services/riverpod.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final isSignedIn = await GoogleSignIn().isSignedIn();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isSignedIn = ref.watch(isGoogleSignedIn);

    final router = GoRouter(
      initialLocation: '/splashScreen',
      routes: [
        GoRoute(path: '/', builder: (context, state) => HomeScreen(), routes: [
          GoRoute(
            path: 'settingsScreen',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'profileScreen',
            builder: (context, state) {
              return ProfileScreen(user: ref.watch(currentUserProvider));
            },
          ),
          // GoRoute(
          //   path: 'personalChatScreen',
          //   builder: (context, state) {
          //     return PersonalChatScreen(user: );
          //   },
          // ),
        ]),
        GoRoute(
          path: '/loginScreen',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
            path: '/splashScreen',
            builder: (context, state) => const SplashScreen()),
      ],
    );
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
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
    );
  }
}
