part of 'statistic_bloc.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();

  @override
  List<Object> get props => [];
}

class StatisticLoadData extends StatisticEvent {
  final DateTime dateTime;

  StatisticLoadData({required this.dateTime});

  @override
  List<Object> get props => [
        dateTime,
      ];
}
