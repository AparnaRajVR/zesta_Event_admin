import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/screen/category_content.dart';
import 'package:z_admin/view/screen/entry/login.dart';
import 'package:z_admin/view/widget/organizer_list.dart';
import 'package:z_admin/view/screen/permission_screen.dart';
import 'package:z_admin/view/widget/dashboard_layout.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_bloc.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_event.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ValueNotifier<Widget> _selectedScreen =
      ValueNotifier(DashboardContent());

  final List<Map<String, dynamic>> _navigationItems = [
    {
      'icon': Icons.dashboard,
      'label': 'Dashboard',
      'screen': DashboardContent()
    },
    {
      'icon': Icons.people_outline,
      'label': 'Organizers',
      'screen': OrganizerListPage()
    },
    {
      'icon': Icons.verified,
      'label': 'Permissions',
      'screen': PermissionsPage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardBloc()..add(LoadDashboardData())),
      ],
      child: DashboardLayout(
        selectedScreen: _selectedScreen,
        navigationItems: _navigationItems,
        onLogout: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        ),
      ),
    );
  }
}
