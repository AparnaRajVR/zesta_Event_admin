
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/screen/category_add.dart';
import 'package:z_admin/view/widget/chart.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_bloc.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_state.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildCarousel(),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Dashboard Overview',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatsCards(state.stats, context),
                const SizedBox(height: 24),
                const DashboardChart(),

              ],
            ),
          );
        } else if (state is DashboardError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox(); // For DashboardInitial
      },
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
              height: constraints.maxWidth * 0.3,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
            ),
            items: images.map((imagePath) {
              return Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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

  Widget _buildStatsCards(List<Map<String, dynamic>> stats, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 800) crossAxisCount = 2;
        if (constraints.maxWidth < 600) crossAxisCount = 1;

        final cards = stats
            .map((stat) => _statCard(stat['label'], stat['value'], stat['color']))
            .toList();

        cards.add(_addCategoryCard(context)); // ✅ add category card

        return GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: cards,
        );
      },
    );
  }

  Widget _statCard(String title, int value, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _addCategoryCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) =>  CategoryDialog(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue.shade50,
        ),
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            '➕ Create Category',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}