import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Map<String, dynamic>> stats;

  DashboardLoaded(this.stats);

  @override
  List<Object> get props => [stats];
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
