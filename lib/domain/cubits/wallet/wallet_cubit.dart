import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/models/transaction.dart'
    as t;
import 'package:personal_financial_management/domain/models/wallet.dart';
import 'package:personal_financial_management/domain/repositories/repositories.dart';
import 'package:personal_financial_management/domain/repositories/transaction_repo.dart';
part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());
  final TransactionRepository _transactionRepository = TransactionRepository();
  void getWalletTransactions(
    String walletId,
  ) async {
    List<t.Transaction> allWalletTransactions =
        await _transactionRepository.getWalletTransactions(walletId);
    allWalletTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (allWalletTransactions.isNotEmpty) {
      emit(state.copyWith(walletTransitions: allWalletTransactions));
    }
  }

  void createNewWallet({
    required num amount,
    required String name,
    required String type,
    required String description,
  }) async {
    final Wallet newWallet = await WalletRepository().createWallet(
      amount,
      name,
      type,
      description,
    );
  }
}
