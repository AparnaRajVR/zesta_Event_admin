import 'package:flutter/material.dart';
import 'package:z_admin/view/widget/appbar.dart';
import 'package:z_admin/view/widget/bottom_nav.dart';
import 'package:z_admin/view/widget/drawer.dart';


class DashboardLayout extends StatelessWidget {
  final ValueNotifier<Widget> selectedScreen;
  final List<Map<String, dynamic>> navigationItems;
  final VoidCallback onLogout;

  const DashboardLayout({
    super.key,
    required this.selectedScreen,
    required this.navigationItems,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1000;
        final isTablet = constraints.maxWidth > 520;
        final isPhone = constraints.maxWidth <= 520;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: DashboardAppBar(
            isDesktop: isDesktop,
            selectedScreen: selectedScreen,
            navigationItems: navigationItems,
            onLogout: onLogout,
          ),
          drawer: isTablet
              ? DashboardDrawer(
                  selectedScreen: selectedScreen,
                  navigationItems: navigationItems,
                  onLogout: onLogout,
                )
              : null,
          body: ValueListenableBuilder(
            valueListenable: selectedScreen,
            builder: (_, screen, __) => screen,
          ),
          bottomNavigationBar: isPhone
              ? DashboardBottomNavBar(
                  selectedScreen: selectedScreen,
                  navigationItems: navigationItems,
                )
              : null,
        );
      },
    );
  }
}
