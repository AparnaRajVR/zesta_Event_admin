import 'dart:ui';

class DashboardStats {
  final String label;
  final int amount;
  final Color color;
  final String trend;

  DashboardStats(
      {required this.label,
      required this.amount,
      required this.color,
      required this.trend});
}
