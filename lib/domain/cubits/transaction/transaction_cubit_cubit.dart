import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_financial_management/domain/repositories/transaction_repo.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;
part 'transaction_cubit_state.dart';

class TransactionCubit extends Cubit<TransactionCubitState> {
  TransactionCubit() : super(TransactionCubitInitial());
  void createNewTransaction({
    required num amount,
    required bool is_output,
    required String category_id,
    required String wallet_id,
  }) async {
    final t.Transaction newTransaction =
        await TransactionRepository().createTransaction(
      amount,
      is_output,
      category_id,
      wallet_id,
    );
    print("createNewTransaction");
  }
}
