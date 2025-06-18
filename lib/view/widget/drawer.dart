import 'package:flutter/material.dart';

class DashboardDrawer extends StatelessWidget {
  final ValueNotifier<Widget> selectedScreen;
  final List<Map<String, dynamic>> navigationItems;
  final VoidCallback onLogout;

  const DashboardDrawer({
    super.key,
    required this.selectedScreen,
    required this.navigationItems,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidget = selectedScreen.value;
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.admin_panel_settings, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text('Admin Panel',
                    style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: navigationItems.map((item) {
                return ListTile(
                  leading: Icon(item['icon'],
                      color: currentWidget.runtimeType == item['screen'].runtimeType
                          ? Colors.blue
                          : Colors.grey),
                  title: Text(item['label'],
                      style: TextStyle(
                        color: currentWidget.runtimeType == item['screen'].runtimeType
                            ? Colors.blue
                            : Colors.grey[700],
                        fontWeight: currentWidget.runtimeType == item['screen'].runtimeType
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  onTap: () {
                    selectedScreen.value = item['screen'];
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.grey),
            title: Text('Logout', style: TextStyle(color: Colors.grey[700])),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
