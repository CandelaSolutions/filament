import 'package:flutter/material.dart';

BottomNavigationBar navBar(
    final theme,
    final hierachry,
    var selectedIndex,
    void Function(int) onDestinationSelected,
    List<BottomNavigationBarItem> destinations) {
  dynamic primaryShade;
  if (hierachry == 0) {
    primaryShade = theme.colorScheme.primary;
  } else {
    primaryShade = theme.colorScheme.secondary;
  }
  final backgroundShade = theme.colorScheme.background;
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: primaryShade,
    selectedItemColor: backgroundShade,
    unselectedItemColor: backgroundShade,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    currentIndex: selectedIndex,
    onTap: onDestinationSelected,
    items: destinations,
  );
}

BottomNavigationBarItem navBarItem(
    IconData iconData, String name, final theme, final hierachry) {
  dynamic primaryShade;
  if (hierachry == 0) {
    primaryShade = theme.colorScheme.primary;
  } else {
    primaryShade = theme.colorScheme.secondary;
  }
  return BottomNavigationBarItem(
    icon: Icon(
      iconData,
    ),
    activeIcon: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.background),
        padding: const EdgeInsets.all(8),
        child: Icon(iconData, color: primaryShade)),
    label: name,
  );
}
