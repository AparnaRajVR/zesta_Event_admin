import 'package:flutter/material.dart';

class DashboardBottomNavBar extends StatelessWidget {
  final ValueNotifier<Widget> selectedScreen;
  final List<Map<String, dynamic>> navigationItems;

  const DashboardBottomNavBar({
    super.key,
    required this.selectedScreen,
    required this.navigationItems,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: navigationItems.indexWhere(
        (item) => selectedScreen.value.runtimeType == item['screen'].runtimeType,
      ),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        selectedScreen.value = navigationItems[index]['screen'];
      },
      items: navigationItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item['icon']),
          label: item['label'],
        );
      }).toList(),
    );
  }
}
