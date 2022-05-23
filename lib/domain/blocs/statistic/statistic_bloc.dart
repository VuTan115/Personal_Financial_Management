import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(StatisticInitial()) {
    on<StatisticLoadData>(_onStatisticLoadData);
  }

  void _onStatisticLoadData(
      StatisticEvent event, Emitter<StatisticState> emit) {
    emit(state.copyWith(status: StatisticStatus.loaded, data: {
      "totalBudget": 10000,
      "categories": [
        {
          "id": "1",
          "name": "Ăn uống",
          "budget": 0,
          "spent": 0,
        },
      ],
    }));
  }
}
