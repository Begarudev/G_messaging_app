import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:twitter_messaging_app/constants/assets.dart';
import 'package:twitter_messaging_app/screens/chat_screen.dart';
import 'package:twitter_messaging_app/screens/profile_screen.dart';
import 'package:twitter_messaging_app/screens/splash_screen.dart';

import '../Widgets/my_navigation_bar.dart';
import '../main.dart';
import '../services/apis.dart';
import '../services/riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      log("status: $message");
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return ref.watch(APIs.getSelfInfoProivder).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(user: ref.watch(currentUserProvider)),
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.person),
                ),
                toolbarHeight: 90,
                actions: [
                  IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        // ctx.push('/settingsScreen');
                      },
                      icon: const Icon(
                        CupertinoIcons.settings,
                        size: 30,
                      ))
                ],
                title: [
                  Center(
                    child: Image.asset(
                      Assets.resourceGarudaMessagingApp,
                      height: 90,
                    ),
                  ),
                  const TextField(
                    enabled: false,
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Assets.resourceGrookIconFilled,
                          height: 25,
                        ),
                        const Gap(10),
                        const Text("Grok"),
                      ],
                    ),
                  ),
                  const Text("Notifications"),
                  const TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  )
                ][ref.watch(selectedIndexProvider)],
              ),
              //
              bottomNavigationBar: MyNavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                onItemTap: (int tappedIndex) {
                  log('Tapped index: $tappedIndex');
                },
                destinations: [
                  NavigationDestination(
                    selectedIcon: const Icon(
                      Icons.home_filled,
                      // color: Colors.white,
                    ),
                    icon: SvgPicture.asset(
                      Assets.resourcePageHomepageHomepagesIcon,
                      // theme: const SvgTheme(currentColor: Colors.white),
                    ),
                    label: 'Home',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(CupertinoIcons.compass_fill),
                    icon: Icon(
                      CupertinoIcons.compass,
                      // color: Colors.white,
                    ),
                    label: 'Explore',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      Assets.resourceGrookIcon,
                      height: 20,
                    ),
                    selectedIcon: SvgPicture.asset(
                      Assets.resourceGrookIconFilled,
                      height: 20,
                    ),
                    label: 'Grook',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(
                      CupertinoIcons.bell_fill,
                      // color: Colors.white,
                    ),
                    icon: Icon(
                      CupertinoIcons.bell,
                      // color: Colors.white,
                    ),
                    label: 'Notifications',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(
                      CupertinoIcons.mail_solid,
                      // color: Colors.white,
                    ),
                    icon: Icon(
                      CupertinoIcons.mail,
                      // color: Colors.white,
                    ),
                    label: 'Messages',
                  ),
                ],
              ),
              body: [
                const Center(child: Text("Not Implemented")),
                const Center(child: Text("Not Implemented")),
                const Center(child: Text("Not Implemented")),
                const Center(child: Text("Not Implemented")),
                const ChatScreen(),
              ][ref.watch(selectedIndexProvider)],
            );
          },
          error: (error, stackTrace) => Center(
            child: Text("Error: $error"),
          ),
          loading: () => const SplashScreen(),
        );
  }
}
