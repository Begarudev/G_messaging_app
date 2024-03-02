import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_messaging_app/constants/assets.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';
import 'package:twitter_messaging_app/screens/chat_screen.dart';

import '../main.dart';
import '../services/apis.dart';
import '../services/riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  List<ChatUser> list = [];

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: APIs.getAllUsers(),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            widget.list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            if (widget.list.isNotEmpty) {
              return Scaffold(
                // drawer: Drawer(
                //   child: ProfileScreen(user: list[0]),
                // ),
                appBar: [
                  AppBar(
                    leading: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        context.push('/profileScreen');
                      },
                      icon: /*ClipOval(
                  child: Image.network(
                    GoogleSignInService().user!.photoURL!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>*/
                          const Icon(CupertinoIcons.person),
                      //   ),
                      // ),
                    ),
                    toolbarHeight: 90,
                    actions: [
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            ctx.push('/settingsScreen');
                          },
                          icon: const Icon(
                            CupertinoIcons.settings,
                            size: 30,
                          ))
                    ],
                    title: Center(
                      child: Image.asset(
                        Assets.resourceGarudaMessagingApp,
                        height: 90,
                      ),
                    ),
                  ),
                  AppBar(
                    leading: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        context.push('/profileScreen');
                      },
                      icon: /*ClipOval(
                  child: Image.network(
                    GoogleSignInService().user!.photoURL!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>*/
                          const Icon(CupertinoIcons.person),
                      //   ),
                      // ),
                    ),
                    toolbarHeight: 90,
                    actions: [
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            ctx.push('/settingsScreen');
                          },
                          icon: const Icon(
                            CupertinoIcons.settings,
                            size: 30,
                          ))
                    ],
                    title: const TextField(),
                  ),
                  AppBar(
                    leading: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        context.push('/profileScreen');
                      },
                      icon: /*ClipOval(
                  child: Image.network(
                    GoogleSignInService().user!.photoURL!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>*/
                          const Icon(CupertinoIcons.person),
                      //   ),
                      // ),
                    ),
                    toolbarHeight: 90,
                    actions: [
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            ctx.push('/settingsScreen');
                          },
                          icon: const Icon(
                            CupertinoIcons.settings,
                            size: 30,
                          ))
                    ],
                    title: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Assets.resourceGrookIconFilled,
                            height: 25,
                          ),
                          const Gap(10),
                          const Text("Grok")
                        ],
                      ),
                    ),
                  ),
                  AppBar(
                    leading: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        context.push('/profileScreen');
                      },
                      icon: /*ClipOval(
                  child: Image.network(
                    GoogleSignInService().user!.photoURL!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>*/
                          const Icon(CupertinoIcons.person),
                      //   ),
                      // ),
                    ),
                    toolbarHeight: 90,
                    actions: [
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            ctx.push('/settingsScreen');
                          },
                          icon: const Icon(
                            CupertinoIcons.settings,
                            size: 30,
                          ))
                    ],
                    title: const Text("Notifications"),
                  ),
                  AppBar(
                    leading: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        context.push('/profileScreen');
                      },
                      icon: /*ClipOval(
                  child: Image.network(
                    GoogleSignInService().user!.photoURL!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>*/
                          const Icon(CupertinoIcons.person),
                      //   ),
                      // ),
                    ),
                    toolbarHeight: 90,
                    actions: [
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            ctx.push('/settingsScreen');
                          },
                          icon: const Icon(
                            CupertinoIcons.settings,
                            size: 30,
                          ))
                    ],
                    title: const TextField(
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ][ref.watch(selectedIndexProvider)],
                bottomNavigationBar: MyNavigationBar(
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  onItemTap: (int tappedIndex) {
                    print('Tapped index: $tappedIndex');
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
                  ChatScreen(
                    list: widget.list,
                  ),
                ][ref.watch(selectedIndexProvider)],
              );
            } else {
              return const Text("No Connections Found");
            }
        }
      },
    );
  }
}

class MyNavigationBar extends ConsumerWidget {
  final List<NavigationDestination> destinations;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final int selectedIndex;
  final void Function(int index) onItemTap;
  final Color? backgroundColor;

  const MyNavigationBar({
    super.key,
    required this.onItemTap,
    required this.destinations,
    this.selectedIndex = 0,
    this.backgroundColor,
    this.labelBehavior,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexState = ref.watch(selectedIndexProvider);
    return NavigationBar(
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelBehavior: labelBehavior,
      backgroundColor: backgroundColor,
      selectedIndex: selectedIndexState,
      onDestinationSelected: (int tappedIndex) {
        ref
            .watch(selectedIndexProvider.notifier)
            .update((state) => tappedIndex);
        onItemTap(tappedIndex);
      },
      destinations: destinations,
    );
  }
}
