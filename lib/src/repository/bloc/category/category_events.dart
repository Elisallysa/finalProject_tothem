import 'package:equatable/equatable.dart';

import '../../../models/course_category.dart';

class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class UpdateCategories extends CategoryEvent {
  final List<CourseCategory> categories;

  UpdateCategories(this.categories);

  @override
  List<Object?> get props => [categories];
}
