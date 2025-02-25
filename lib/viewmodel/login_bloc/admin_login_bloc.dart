import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_admin/viewmodel/login_bloc/admin_login_event.dart';
import 'package:z_admin/viewmodel/login_bloc/admin_login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
       
        final docSnapshot = await _firestore
            .collection('admin')
            .doc('credentials')
            .get();

        if (!docSnapshot.exists) {
          emit(LoginFailure("Admin credentials not found"));
          return;
        }

        final data = docSnapshot.data()!;
        final storedUsername = data['username'] as String;
        final storedPassword = data['password'] as String;

        
        if (event.username == storedUsername && 
            event.password == storedPassword) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure("Invalid credentials"));
        }
      } catch (e) {
        emit(LoginFailure("Error during login: $e"));
      }
    });
  }
}