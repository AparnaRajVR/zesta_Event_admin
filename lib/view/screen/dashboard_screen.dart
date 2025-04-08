
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/screen/category%20content.dart';
import 'package:z_admin/view/screen/entry/login.dart';
import 'package:z_admin/view/screen/organizer_list.dart';
import 'package:z_admin/view/screen/permission_screen.dart';
import 'package:z_admin/view/screen/report_screen.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_bloc.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_event.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ValueNotifier<Widget> _selectedScreen = ValueNotifier(DashboardContent());
  final List<Map<String, dynamic>> _navigationItems = [
    {'icon': Icons.dashboard, 'label': 'Dashboard', 'screen': DashboardContent()},
    {'icon': Icons.people_outline, 'label': 'Organizers', 'screen': OrganizerListPage()},
    {'icon': Icons.verified, 'label': 'Permissions', 'screen': PermissionsPage()},
    {'icon': Icons.report_outlined, 'label': 'Reports', 'screen': ReportsScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardBloc()..add(LoadDashboardData())),
        // BlocProvider(create: (_) => DashboardCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1000;
          final isTablet = constraints.maxWidth > 520;
          final isPhone = constraints.maxWidth <= 520;

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 4,
              leadingWidth: isDesktop ? 250 : null,
              leading: isDesktop ? appLogo(context) : null,
              title: !isDesktop ? appLogo(context) : null,
              actions: isDesktop
                  ? [
                      ..._navigationItems.asMap().entries.map((entry) {
                        final item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextButton.icon(
                            icon: Icon(item['icon'],
                                color: _selectedScreen.value.runtimeType == item['screen'].runtimeType
                                    ? Colors.blue
                                    : Colors.grey),
                            label: Text(item['label'],
                                style: TextStyle(
                                  color: _selectedScreen.value.runtimeType == item['screen'].runtimeType
                                      ? Colors.blue
                                      : Colors.grey[700],
                                  fontWeight: _selectedScreen.value.runtimeType == item['screen'].runtimeType
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                )),
                            onPressed: () => _selectedScreen.value = item['screen'],
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
                          onPressed: () => Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (_) => LoginPage())),
                        ),
                      ),
                    ]
                  : null,
            ),
            drawer: isTablet ? _buildDrawer(context) : null,
            body: ValueListenableBuilder(
              valueListenable: _selectedScreen,
              builder: (_, screen, __) => screen,
            ),
            bottomNavigationBar: isPhone
                ? ValueListenableBuilder(
                    valueListenable: _selectedScreen,
                    builder: (_, screen, __) {
                      return BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: _navigationItems.indexWhere(
                          (item) => screen.runtimeType == item['screen'].runtimeType,
                        ),
                        selectedItemColor: Colors.blue,
                        unselectedItemColor: Colors.grey,
                        onTap: (index) {
                          _selectedScreen.value = _navigationItems[index]['screen'];
                        },
                        items: _navigationItems.map((item) {
                          return BottomNavigationBarItem(
                            icon: Icon(item['icon']),
                            label: item['label'],
                          );
                        }).toList(),
                      );
                    },
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget appLogo(BuildContext context) {
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

  Widget _buildDrawer(BuildContext context) {
    final currentWidget = _selectedScreen.value;
    return Drawer(
      elevation: 4,
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
              children: _navigationItems.asMap().entries.map((entry) {
                final item = entry.value;
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
                    _selectedScreen.value = item['screen'];
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          _drawerItem(context, Icons.logout, 'Logout',
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()))),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: TextStyle(color: Colors.grey[700])),
      onTap: onTap,
    );
  }
}
