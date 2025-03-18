// import 'package:equatable/equatable.dart';

// abstract class LoginState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {}

// class LoginFailure extends LoginState {
//   final String error;

//   LoginFailure(this.error, {required String error});

//   @override
//   List<Object?> get props => [error];
// }


import 'package:equatable/equatable.dart';

abstract class AdminLoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends AdminLoginState {}

class LoginLoading extends AdminLoginState {}

class LoginSuccess extends AdminLoginState {}

class LoginFailure extends AdminLoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
