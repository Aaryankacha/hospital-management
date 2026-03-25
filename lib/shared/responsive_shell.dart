import 'package:flutter/material.dart';
import 'package:src/shared/custom_style.dart';

class ResponsiveShell extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onIndexChanged;
  final List<NavigationItem> items;

  const ResponsiveShell({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.items,
  }) : super(key: key);

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.items.isEmpty) return widget.child;

        int safeIndex = widget.currentIndex;
        if (safeIndex < 0 || safeIndex >= widget.items.length) {
          safeIndex = 0;
        }

        if (constraints.maxWidth > 800) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth > 1200,
                  destinations: widget.items.map((item) {
                    return NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    );
                  }).toList(),
                  selectedIndex: safeIndex,
                  onDestinationSelected: widget.onIndexChanged,
                  backgroundColor: cSecondaryAzure,
                  selectedIconTheme: const IconThemeData(color: cPrimaryBlue),
                  selectedLabelTextStyle: cNavText,
                  unselectedLabelTextStyle: cNavText.copyWith(color: Colors.grey),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: widget.child),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: widget.child,
            bottomNavigationBar: widget.items.length >= 2 ? NavigationBar(
              selectedIndex: safeIndex,
              onDestinationSelected: widget.onIndexChanged,
              destinations: widget.items.map((item) {
                return NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                );
              }).toList(),
              backgroundColor: Colors.white,
              indicatorColor: cSecondaryAzure,
            ) : null,
          );
        }
      },
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}
