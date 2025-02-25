import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_event.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  void _onLoadDashboardData(
      LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      final stats = [
        {'label': 'Total Organizer', 'value': 2500, 'trend': '+14%', 'color': Colors.blue},
        {'label': 'Active Events', 'value': 4533, 'trend': '+5%', 'color': Colors.purple},
        {'label': 'Booked Tickets', 'value': 9574, 'trend': '+11%', 'color': Colors.indigo},
      ];

      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError("Failed to load data"));
    }
  }
}
