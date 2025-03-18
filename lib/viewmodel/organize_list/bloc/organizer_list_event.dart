import 'package:equatable/equatable.dart';

abstract class OrganizerEvent extends Equatable {
  const OrganizerEvent();
  @override
  List<Object> get props => [];
}

class FilterStatusChanged extends OrganizerEvent {
  final String status;
  const FilterStatusChanged(this.status);
  @override
  List<Object> get props => [status];
}

class SearchQueryChanged extends OrganizerEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

class UpdateOrganizerStatus extends OrganizerEvent {
  final String docId;
  final String status;
  const UpdateOrganizerStatus(this.docId, this.status);
  @override
  List<Object> get props => [docId, status];
}