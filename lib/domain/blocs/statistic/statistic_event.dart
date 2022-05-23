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

class StatisticUpdateCategory extends StatisticEvent {
  StatisticUpdateCategory({
    required this.dateTime,
  });
  DateTime dateTime;
  @override
  List<Object> get props => [];
}

class StatisticCreateCategory extends StatisticEvent {
  StatisticCreateCategory({
    required this.categoryId,
    required this.amount,
    required this.dateTime
  });
  String categoryId;
  num amount;
  DateTime dateTime;
  @override
  List<Object> get props => [categoryId, amount,dateTime];
}
