part of 'dashboard_bloc_bloc.dart';

sealed class DashboardBlocState extends Equatable {
  const DashboardBlocState();
  
  @override
  List<Object> get props => [];
}

final class DashboardBlocInitial extends DashboardBlocState {}
