import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/repositories/transaction_repo.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;
part 'transaction_cubit_state.dart';

class TransactionCubit extends Cubit<TransactionCubitState> {
  TransactionCubit() : super(TransactionCubitInitial());

  // late final StreamSubscription homeBlocSubscription;

  void createNewTransaction({
    required num amount,
    required bool is_output,
    required String category,
    required String wallet,
    required DateTime created_at,
  }) async {
    final t.Transaction newTransaction =
        await TransactionRepository().createTransaction(
      amount,
      is_output,
      category,
      wallet,
      created_at,
    );
  }
}
