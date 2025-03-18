import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_event.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_state.dart';




// 🔸 Bloc Logic
class ApprovalBloc extends Bloc<ApprovalEvent, ApprovalState> {
  final FirebaseFirestore firestore;

  ApprovalBloc({required this.firestore}) : super(ApprovalInitial()) {
    on<FetchUserData>(_fetchUserData);
    on<UpdateUserStatus>(_updateUserStatus);
  }

  Future<void> _fetchUserData(FetchUserData event, Emitter<ApprovalState> emit) async {
    emit(ApprovalLoading());
    try {
      final doc = await firestore.collection('users').doc(event.userId).get();
      if (!doc.exists) {
        emit(ApprovalError("User not found"));
        return;
      }
      emit(ApprovalLoaded(doc));
    } catch (e) {
      emit(ApprovalError(e.toString()));
    }
  }

  Future<void> _updateUserStatus(UpdateUserStatus event, Emitter<ApprovalState> emit) async {
    try {
      await firestore.collection('users').doc(event.userId).update({'status': event.status});
      emit(StatusUpdated(event.status));
    } catch (e) {
      emit(ApprovalError("Failed to update status"));
    }
  }
}
