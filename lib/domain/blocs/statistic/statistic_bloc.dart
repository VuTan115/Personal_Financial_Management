import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_financial_management/domain/repositories/budget_repo.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(StatisticInitial()) {
    on<StatisticLoadData>(_onStatisticLoadData);
    on<StatisticUpdateCategory>(_onStatisticUpdateCategory);
    on<StatisticCreateCategory>(_onStatisticCreateCategory);
  }

  void _onStatisticLoadData(
      StatisticLoadData event, Emitter<StatisticState> emit) async {
    final Map<String, dynamic> budgetDetail =
        await BudgetRepository().getBudgetDetail(event.dateTime);
    //update categorues limits_per_month = budget
    final List<dynamic> categories = budgetDetail["categories"];
    categories.forEach((category) {
      category["budget"] = category["limits_per_month"];
    });
    budgetDetail["categories"] = categories;

    emit(state.copyWith(
        status: StatisticStatus.loaded,
        data: budgetDetail,
        dateTime: event.dateTime.toString()));
  }

  void _onStatisticUpdateCategory(
      StatisticUpdateCategory event, Emitter<StatisticState> emit) async {
    print("supppp${state}");
    final Map<String, dynamic> budgetDetail =
        await BudgetRepository().getBudgetDetail(event.dateTime);
    //update categorues limits_per_month = budget
    final List<dynamic> categories = budgetDetail["categories"];
    categories.forEach((category) {
      category["budget"] = category["limits_per_month"];
    });
    budgetDetail["categories"] = categories;
    emit(StatisticState(
        status: StatisticStatus.updated,
        data: budgetDetail,
        dateTime: event.dateTime.toString()));
  }

  void _onStatisticCreateCategory(
      StatisticCreateCategory event, Emitter<StatisticState> emit) async {
    print("state Date${event}");
    final String budgetDetail = await BudgetRepository().createCategoryBudget(
      timestamp: event.dateTime,
      category_id: event.categoryId,
      amount: event.amount,
    );
    print(budgetDetail);
    emit(StatisticCategoryUpdated());
  }
}
