part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  // final List<String> catrgories ;

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryCreated extends CategoryState {
  final String name;
  final String icon;

  CategoryCreated({required this.name, required this.icon});

  @override
  List<Object> get props => [name, icon];
}
