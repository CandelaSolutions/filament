import 'package:flutter/material.dart';

NavigationRail navRail(
    final theme,
    final hierachry,
    var selectedIndex,
    void Function(int) onDestinationSelected,
    List<NavigationRailDestination> destinations) {
  dynamic primaryShade;
  if (hierachry == 0) {
    primaryShade = theme.colorScheme.primary;
  } else {
    primaryShade = theme.colorScheme.secondary;
  }
  final backgroundShade = theme.colorScheme.background;
  return NavigationRail(
    backgroundColor: primaryShade,
    indicatorColor: backgroundShade,
    //indicatorShape: BoxBorder,
    extended: false,
    destinations: destinations,
    selectedIndex: selectedIndex,
    onDestinationSelected: onDestinationSelected,
  );
}

NavigationRailDestination railDestination(
    IconData iconData, String name, final theme, final hierachry) {
  dynamic primaryShade;
  if (hierachry%2 == 0) {
    primaryShade = theme.colorScheme.primary;
  } else {
    primaryShade = theme.colorScheme.secondary;
  }
  final backgroundShade = theme.colorScheme.background;
  final labelStyle = theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.background,
  );
  return NavigationRailDestination(
    icon: Icon(
      iconData,
      color: backgroundShade,
    ),
    selectedIcon: Icon(iconData, color: primaryShade),
    label: Text(name, style: labelStyle),
  );
}