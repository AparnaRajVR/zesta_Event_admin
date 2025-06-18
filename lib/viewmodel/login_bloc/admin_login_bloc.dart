


// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'admin_login_event.dart';
// import 'admin_login_state.dart';

// class LoginBloc extends Bloc<AdminLoginEvent, AdminLoginState> {
//   final String _adminUsername = "admin@gmail.com";
//   final String _adminPassword = "123456";

//   LoginBloc() : super(LoginInitial()) {
//     on<LoginButtonPressed>((event, emit) async {
//       emit(LoginLoading());

//       await Future.delayed(const Duration(seconds: 1)); // Simulate network call

//       if (event.username == _adminUsername && event.password == _adminPassword) {
//         emit(LoginSuccess());
//       } else {
//         emit(LoginFailure(error: "Invalid username or password"));
//       }
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_login_event.dart';
import 'admin_login_state.dart';

class LoginBloc extends Bloc<AdminLoginEvent, AdminLoginState> {
  final String _adminUsername = "admin@gmail.com";
  final String _adminPassword = "123456";

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      await Future.delayed(const Duration(seconds: 1)); // Simulate network call

      if (event.username == _adminUsername && event.password == _adminPassword) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: "Invalid username or password"));
      }
    });

    // Add a new event to check login status on app start
    on<CheckLoginStatus>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        emit(LoginSuccess());
      } else {
        emit(LoginInitial());
      }
    });

    // Add a logout event for completeness
    on<LogoutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      emit(LoginInitial());
    });
  }
}
