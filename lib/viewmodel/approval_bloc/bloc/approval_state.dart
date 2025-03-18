
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ApprovalState extends Equatable {
  @override
  List<Object> get props => [];
}

class ApprovalInitial extends ApprovalState {}

class ApprovalLoading extends ApprovalState {}

class ApprovalLoaded extends ApprovalState {
  final DocumentSnapshot user;
  ApprovalLoaded(this.user);
}

class ApprovalError extends ApprovalState {
  final String message;
  ApprovalError(this.message);
}

class StatusUpdated extends ApprovalState {
  final String status;
  StatusUpdated(this.status);
}
