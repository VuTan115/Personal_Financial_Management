import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_change_state.dart';

class DateChangeCubit extends Cubit<DateChangeState> {
  DateChangeCubit() : super(DateChangeInitial());

  
  void dateChange({required String newDate}) {
    emit(state.copyWith(newDate: newDate));
  }
}
