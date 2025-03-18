import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_event.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_state.dart';


class OrganizerBloc extends Bloc<OrganizerEvent, OrganizerState> {
  OrganizerBloc() : super(const OrganizerState()) {
    on<FilterStatusChanged>((event, emit) {
      emit(state.copyWith(filterStatus: event.status));
    });

    on<SearchQueryChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });

    on<UpdateOrganizerStatus>((event, emit) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(event.docId)
          .update({'status': event.status});
    });
  }
}