import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/repository/category_repository/category_repository.dart';

import 'category_events.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  StreamSubscription? _categorySubscription;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryLoading()) {
    on<LoadCategories>((event, emit) async {
      await _mapLoadCategoriesToState(emit);
    });
    on<UpdateCategories>(
        (event, emit) => _mapUpdateCategoriesToState(event, emit));
  }

  Future<void> _mapLoadCategoriesToState(Emitter<CategoryState> emit) async {
    _categorySubscription?.cancel();
    _categorySubscription = _categoryRepository
        .getAllCategories()
        .listen((categories) => add(UpdateCategories(categories)));
  }

  Future<void> _mapUpdateCategoriesToState(
      UpdateCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoaded(categories: event.categories));
  }
}
