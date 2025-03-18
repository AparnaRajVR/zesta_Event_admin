// 🔸 Events
import 'package:equatable/equatable.dart';

abstract class ApprovalEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserData extends ApprovalEvent {
  final String userId;
  FetchUserData(this.userId);
}

class UpdateUserStatus extends ApprovalEvent {
  final String userId;
  final String status;
  UpdateUserStatus(this.userId, this.status);
}