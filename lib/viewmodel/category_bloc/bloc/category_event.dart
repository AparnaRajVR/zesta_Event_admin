// import 'package:equatable/equatable.dart';

// abstract class CategoryEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class LoadCategories extends CategoryEvent {}

// class AddCategory extends CategoryEvent {
//   final String name;
//   AddCategory(this.name);

//   @override
//   List<Object?> get props => [name];
// }

// class DeleteCategory extends CategoryEvent {
//   final String id;
//   DeleteCategory(this.id);

//   @override
//   List<Object?> get props => [id];
// }


import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;

  AddCategory(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteCategory extends CategoryEvent {
  final String id;

  DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}
