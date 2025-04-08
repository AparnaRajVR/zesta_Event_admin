

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/service/category_service.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService _service = CategoryService();

  CategoryBloc() : super(CategoryInitial()) {
    // Load categories once and emit
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categoriesStream = _service.getCategories();
        await emit.forEach(
          categoriesStream,
          onData: (categories) => CategoryLoaded(categories),
          onError: (error, stackTrace) => CategoryError(error.toString()),
        );
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategory>((event, emit) async {
      await _service.addCategory(event.name);
    });

    on<DeleteCategory>((event, emit) async {
      await _service.deleteCategory(event.id);
    });
  }
}

