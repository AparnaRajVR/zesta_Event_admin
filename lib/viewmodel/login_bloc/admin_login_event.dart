
// import 'package:equatable/equatable.dart';

// abstract class AdminLoginEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class LoginButtonPressed extends AdminLoginEvent {
//   final String username;
//   final String password;

//   LoginButtonPressed({required this.username, required this.password});

//   @override
//   List<Object?> get props => [username, password];
// }

abstract class AdminLoginEvent {}

class LoginButtonPressed extends AdminLoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});
}

class CheckLoginStatus extends AdminLoginEvent {}

class LogoutEvent extends AdminLoginEvent {}
