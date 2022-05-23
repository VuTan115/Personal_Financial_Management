import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_financial_management/domain/models/category.dart';
import 'package:personal_financial_management/domain/repositories/category_repo.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  void createNewCategory({
    required String categoryName,
    required bool isOutput,
  }) async {
    final Category newCategory = await CategoryRepository().createCategory(
      name: categoryName,
      isOutput: isOutput,
    );
    emit(CategoryCreated(name: categoryName, isOutput: isOutput));
  }

  void getCategories({required String type}) async {
    final List<String> categories =
        await CategoryRepository().getCategories(type);

    if (categories.isNotEmpty) {
      emit(state.copyWith(categories: categories));
    }
  }
}
