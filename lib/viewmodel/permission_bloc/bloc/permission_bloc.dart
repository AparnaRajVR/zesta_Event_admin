
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_event.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_state.dart';


class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<FilterUsers>(_onFilterUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<PermissionsState> emit) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').get();
      emit(UsersLoaded(snapshot.docs));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onFilterUsers(FilterUsers event, Emitter<PermissionsState> emit) async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('users');
      if (event.filter != 'All') {
        query = query.where('status', isEqualTo: event.filter.toLowerCase());
      }
      var snapshot = await query.get();

      var filteredUsers = snapshot.docs.where((user) {
        String userName = user['fullName'].toString().toLowerCase();
        return userName.contains(event.searchQuery.toLowerCase());
      }).toList();

      emit(UsersLoaded(filteredUsers));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
