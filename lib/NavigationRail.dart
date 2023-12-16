import 'package:flutter/material.dart';

NavigationRail navRail(
    final theme, var selectedIndex, void Function(int) onDestinationSelected) {
  final primaryShade = theme.colorScheme.primary;
  final backgroundShade = theme.colorScheme.background;
  final labelStyle = theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.background,
  );
  return NavigationRail(
    backgroundColor: primaryShade,
    indicatorColor: backgroundShade,
    extended: false,
    destinations: [
      railDestination(
          Icons.home, "Home", primaryShade, backgroundShade, labelStyle),
      railDestination(Icons.calendar_today, "Calendar", primaryShade,
          backgroundShade, labelStyle),
      railDestination(Icons.checklist, "Check-List", primaryShade,
          backgroundShade, labelStyle),
      railDestination(Icons.contact_mail, "Messages", primaryShade,
          backgroundShade, labelStyle)
    ],
    selectedIndex: selectedIndex,
    onDestinationSelected: onDestinationSelected,
  );
}

NavigationRailDestination railDestination(IconData iconData, String name,
    Color primaryShade, Color backgroundShade, final style) {
  return NavigationRailDestination(
    icon: Icon(
      iconData,
      color: backgroundShade,
    ),
    selectedIcon: Icon(iconData, color: primaryShade),
    label: Text(name, style: style),
  );
}
