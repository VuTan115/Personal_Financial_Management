part of 'statistic_bloc.dart';

enum StatisticStatus { loading, loaded, error, updated, created }

class StatisticState extends Equatable {
  StatisticState({
    this.status = StatisticStatus.loaded,
    this.data = const {},
    this.dateTime = '',
  });

  final StatisticStatus status;
  final Map<String, dynamic> data;
  String dateTime;

  StatisticState copyWith({
    StatisticStatus? status,
    Map<String, dynamic>? data,
    String dateTime = '',
  }) {
    return StatisticState(
      status: status ?? this.status,
      data: data ?? this.data,
      dateTime: dateTime,
    );
  }

  @override
  List<Object> get props => [status, data, dateTime];
}

class StatisticInitial extends StatisticState {}

class StatisticCategoryUpdated extends StatisticState {}

class StatisticToTalBudgetCreated extends StatisticState {}
