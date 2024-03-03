import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/riverpod.dart';

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
