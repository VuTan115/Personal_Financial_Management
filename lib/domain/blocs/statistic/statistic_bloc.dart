import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_financial_management/domain/repositories/budget_repo.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(StatisticInitial()) {
    on<StatisticLoadData>(_onStatisticLoadData);
    on<StatisticUpdateCategory>(_onUpdateCategory);
    on<StatisticCreateCategory>(_onCreateCategory);
    on<StatisticCreateTotalBudget>(_onCreateTotalBudget);
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

  void _onUpdateCategory(
      StatisticUpdateCategory event, Emitter<StatisticState> emit) async {
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

  void _onCreateCategory(
      StatisticCreateCategory event, Emitter<StatisticState> emit) async {
    final String budgetDetail = await BudgetRepository().createCategoryBudget(
      timestamp: event.dateTime,
      category_id: event.categoryId,
      amount: event.amount,
    );
    emit(StatisticCategoryUpdated());
  }

  void _onCreateTotalBudget(
      StatisticCreateTotalBudget event, Emitter<StatisticState> emit) async {
    final res = await BudgetRepository().createTotalBudget(
      timestamp: event.dateTime,
      amount: event.amount,
    );

    print(res);
    emit(StatisticToTalBudgetCreated(totalBudget: res['amount'].toString()));
  }
}
