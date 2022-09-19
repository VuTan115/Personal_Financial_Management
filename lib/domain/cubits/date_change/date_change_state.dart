part of 'date_change_cubit.dart';

class DateChangeState extends Equatable {
  DateChangeState({this.newDate = ''});
  String? newDate;
  DateChangeState copyWith({String? newDate}) {
    return DateChangeState(newDate: newDate ?? this.newDate);
  }

  @override
  List<Object> get props => [];
}

class DateChangeInitial extends DateChangeState {}
