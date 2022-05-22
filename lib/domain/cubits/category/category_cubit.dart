import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  void createNewCategory({
    required String name,
    required String icon,
  }) async {
    emit(CategoryCreated(name: name, icon: icon));
  }
}
