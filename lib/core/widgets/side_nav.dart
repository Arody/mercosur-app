import 'package:flutter/material.dart';

class SideNav extends StatelessWidget {
  const SideNav({super.key, required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.folder_open),
          selectedIcon: Icon(Icons.folder),
          label: Text('Expedientes'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.assignment_ind_outlined),
          selectedIcon: Icon(Icons.assignment_ind),
          label: Text('Supervisor'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: Text('Coordinador'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Reportes'),
        ),
      ],
    );
  }
}

