import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:z_admin/view/screen/entry/login.dart';
import 'package:z_admin/view/screen/organizer_list.dart';
import 'package:z_admin/view/screen/permission_screen.dart';
import 'package:z_admin/view/screen/report_screen.dart';

class DashboardCubit extends Cubit<bool> {
  DashboardCubit() : super(false);
  void toggleDrawer(bool isOpen) => emit(isOpen);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ValueNotifier<Widget> _selectedScreen = ValueNotifier(DashboardContent());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: isDesktop
                ? null
                : AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () => Scaffold.of(context).openDrawer(), // New Change: Open drawer properly
                      ),
                    ),
                    title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
                  ),
            drawer: isDesktop ? null : _buildDrawer(context), // New Change: Ensure drawer opens properly
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop) SizedBox(width: 250, child: _buildDrawer(context)),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _selectedScreen,
                    builder: (context, screen, child) {
                      return screen;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
              children: [
                _drawerItem(context, Icons.dashboard, 'Dashboard', onTap: () => _selectedScreen.value = DashboardContent()),
                _drawerItem(context, Icons.people_outline, 'Organizers', onTap: () => _selectedScreen.value = OrganizerListPage()),
                _drawerItem(context, Icons.verified, 'Permissions', onTap: () => _selectedScreen.value = PermissionsPage()),
                _drawerItem(context, Icons.report_outlined, 'Reports', onTap: () => _selectedScreen.value = ReportsScreen()),
              ],
            ),
          ),
          _drawerItem(context, Icons.logout, 'Logout',
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()))),
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

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _buildCarousel(),
          const SizedBox(height: 24), // New Change: Added space between carousel and title
          Center(child: Text('Dashboard Overview', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final List<String> images = [
      'assets/images/carusel1.jpg',
      'assets/images/carousel2.jpg',
      'assets/images/carousel3.jpeg',
      'assets/images/carousel4.jpeg',
    ];
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth, 
          child: CarouselSlider(
            options: CarouselOptions(
              height: constraints.maxWidth * 0.4, // Adjust height based on width
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0, // Ensures full width
            ),
            items: images.map((imagePath) {
              return Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth / 3 - 20; // Adjust card size dynamically
        double cardHeight = constraints.maxWidth * 0.15; // Adjust height proportionally

        if (constraints.maxWidth < 600) {
          cardWidth = constraints.maxWidth / 2 - 20; // New Change: Adjust width for mobile to prevent overflow
        }

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            _statCard('Total Organizer', 2500, Colors.blue, cardWidth, cardHeight),
            _statCard('Active Events', 4533, Colors.purple, cardWidth, cardHeight),
            _statCard('Booked Tickets', 9574, Colors.indigo, cardWidth, cardHeight),
          ],
        );
      },
    );
  }

  Widget _statCard(String title, int value, Color color, double width, double height) {
    return Container(
      width: width, // Responsive width
      height: height, // Responsive height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
          const SizedBox(height: 8),
          Text(value.toString(), style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(height: 400, child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: [FlSpot(0, 100), FlSpot(1, 125), FlSpot(2, 160)], isCurved: true, color: Colors.blue, barWidth: 3)])));
  }
}
