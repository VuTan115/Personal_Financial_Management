part of 'category_cubit.dart';

class CategoryState extends Equatable {
  const CategoryState({this.categories = const []});

  final List<String> categories;
  CategoryState copyWith({required List<String> categories}) =>
      CategoryState(categories: categories);
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryCreated extends CategoryState {
  final String name;
  final bool isOutput;

  CategoryCreated({required this.name, required this.isOutput});

  @override
  List<Object> get props => [name, isOutput];
}

class CategoryCreating extends CategoryState {}

class CategoryFetching extends CategoryState {}

class CategoryFetched extends CategoryState {
  final List<String> categories;

  CategoryFetched({required this.categories});

  @override
  List<Object> get props => [categories];
}
