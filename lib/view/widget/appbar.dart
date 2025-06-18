import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final ValueNotifier<Widget> selectedScreen;
  final List<Map<String, dynamic>> navigationItems;
  final VoidCallback onLogout;

  const DashboardAppBar({
    super.key,
    required this.isDesktop,
    required this.selectedScreen,
    required this.navigationItems,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      leadingWidth: isDesktop ? 250 : null,
      leading: isDesktop ? _appLogo() : null,
      title: !isDesktop ? _appLogo() : null,
      actions: isDesktop
          ? [
              ...navigationItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton.icon(
                    icon: Icon(item['icon'],
                        color: selectedScreen.value.runtimeType == item['screen'].runtimeType
                            ? Colors.blue
                            : Colors.grey),
                    label: Text(item['label'],
                        style: TextStyle(
                          color: selectedScreen.value.runtimeType == item['screen'].runtimeType
                              ? Colors.blue
                              : Colors.grey[700],
                          fontWeight: selectedScreen.value.runtimeType == item['screen'].runtimeType
                              ? FontWeight.bold
                              : FontWeight.normal,
                        )),
                    onPressed: () => selectedScreen.value = item['screen'],
                  ),
                );
              }).toList(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: VerticalDivider(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  tooltip: 'Logout',
                  onPressed: onLogout,
                ),
              ),
            ]
          : null,
    );
  }

  Widget _appLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('Admin Panel',
              style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
