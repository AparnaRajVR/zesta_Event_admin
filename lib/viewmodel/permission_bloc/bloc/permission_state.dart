import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PermissionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersLoading extends PermissionsState {}

class UsersLoaded extends PermissionsState {
  final List<QueryDocumentSnapshot> users;

  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersError extends PermissionsState {
  final String message;

  UsersError(this.message);

  @override
  List<Object?> get props => [message];
}
