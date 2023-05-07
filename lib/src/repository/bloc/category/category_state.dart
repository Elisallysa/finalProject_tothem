import 'package:equatable/equatable.dart';

import '../../../models/course_category.dart';

class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class InitStates extends CategoryState {
  const InitStates() : super();
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CourseCategory> categories;

  const CategoryLoaded({this.categories = const <CourseCategory>[]});

  @override
  List<Object?> get props => [categories];
}
