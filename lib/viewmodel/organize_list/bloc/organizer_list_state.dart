import 'package:equatable/equatable.dart';

class OrganizerState extends Equatable {
  final String filterStatus;
  final String searchQuery;
  
  const OrganizerState({
    this.filterStatus = 'All',
    this.searchQuery = '',
  });

  OrganizerState copyWith({
    String? filterStatus,
    String? searchQuery,
  }) {
    return OrganizerState(
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [filterStatus, searchQuery];
}