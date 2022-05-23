part of 'statistic_bloc.dart';

enum StatisticStatus {
  loading,
  loaded,
  error,
}

class StatisticState extends Equatable {
  const StatisticState(
      {this.status = StatisticStatus.loaded, this.data = const {}});

  final StatisticStatus status;
  final Map<String, dynamic> data;

  StatisticState copyWith(
      {StatisticStatus? status, Map<String, dynamic>? data}) {
    return StatisticState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}
