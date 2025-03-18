import 'package:equatable/equatable.dart';

abstract class PermissionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUsers extends PermissionsEvent {}

class FilterUsers extends PermissionsEvent {
  final String filter;
  final String searchQuery;

  FilterUsers({required this.filter, required this.searchQuery});

  @override
  List<Object?> get props => [filter, searchQuery];
}
