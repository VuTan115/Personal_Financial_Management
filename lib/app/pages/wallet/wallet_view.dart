import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/pages/wallet/add_wallet.dart';
import 'package:personal_financial_management/app/pages/wallet/wallet_profile.dart';
import 'package:personal_financial_management/app/routes/app_routes.dart';
import 'package:personal_financial_management/app/utils/utils.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/cubits/wallet_cubit/wallet_cubit.dart';
import 'package:personal_financial_management/domain/models/wallet.dart';

class WalletView extends StatefulWidget {
  WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  NavigatorState get _navigator => GlobalKeys.appNavigatorKey.currentState!;

  late Map<String, List<dynamic>> _walletTypes = {
    "bank": <dynamic>[],
    "credit": <dynamic>[],
    "e_wallet": <dynamic>[],
    "stock": <dynamic>[],
    "cash": <dynamic>[],
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.allWallets == null) {
          return const Center(
            child: Text("Không có ví nào"),
          );
        }
        _walletTypes['bank'] = state.allWallets!['bank'] ?? [];
        _walletTypes['credit'] = state.allWallets!['credit'] ?? [];
        _walletTypes['stock'] = state.allWallets!['stock'] ?? [];
        _walletTypes['e_wallet'] = state.allWallets!['e_wallet'] ?? [];
        _walletTypes['cash'] = state.allWallets!['cash'] ?? [];

        return Scaffold(
            backgroundColor: MyAppColors.white000,
            body: _buildWalletsView(wallets: _walletTypes));
      },
    );
  }

  Widget _buildBankWalletView({required List<dynamic> banks}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: banks
                .map((e) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: MyAppColors.gray400)),
                      ),
                      child: ListTile(
                        onTap: () => onWalletTap(wallet: e),
                        leading: MyAppIcons.bank,
                        title: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              e.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: MyAppColors.gray800,
                              ),
                            )),
                        subtitle: Text(e.description.toString()),
                        trailing: Text(
                            "${numberFormat.format(e.amount.toInt())} VND"),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _buildCreditWalletView({required List<dynamic> credits}) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Column(
            children: credits
                .map((e) => Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: MyAppColors.gray400)),
                    ),
                    child: ListTile(
                      onTap: () => onWalletTap(wallet: e),
                      leading: MyAppIcons.creditCard,
                      title: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            e.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: MyAppColors.gray800,
                            ),
                          )),
                      subtitle: Text(e.description.toString()),
                      trailing:
                          Text("${numberFormat.format(e.amount.toInt())} VND"),
                    )))
                .toList()),
      )
    ]);
  }

  Widget _buildEWalletView({required List<dynamic> eWallets}) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Column(
            children: eWallets
                .map((e) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: MyAppColors.gray400)),
                      ),
                      child: ListTile(
                        onTap: () => onWalletTap(wallet: e),
                        leading: MyAppIcons.smartPhone,
                        title: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              e.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: MyAppColors.gray800,
                              ),
                            )),
                        subtitle: Text(e.description.toString()),
                        trailing: Text(
                            "${numberFormat.format(e.amount.toInt())} VND"),
                      ),
                    ))
                .toList()),
      )
    ]);
  }

  Widget _buildStockWalletView({required List<dynamic> stocks}) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Column(
            children: stocks
                .map((e) => Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: MyAppColors.gray400)),
                    ),
                    child: ListTile(
                      onTap: () => onWalletTap(wallet: e),
                      leading: MyAppIcons.development,
                      title: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            e.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: MyAppColors.gray800,
                            ),
                          )),
                      subtitle: Text(e.description.toString()),
                      trailing:
                          Text("${numberFormat.format(e.amount.toInt())} VND"),
                    )))
                .toList()),
      )
    ]);
  }

  Widget _buildCashWalletView({required List<dynamic> cashs}) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Column(
            children: cashs
                .map((e) => Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: MyAppColors.gray400)),
                    ),
                    child: ListTile(
                      onTap: () => onWalletTap(wallet: e),
                      leading: MyAppIcons.development,
                      title: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            e.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: MyAppColors.gray800,
                            ),
                          )),
                      subtitle: Text(e.description.toString()),
                      trailing:
                          Text("${numberFormat.format(e.amount.toInt())} VND"),
                    )))
                .toList()),
      )
    ]);
  }

  Widget _buildWalletsView({required Map<String, List<dynamic>> wallets}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            // map wallets to widgets
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Tài khoản ngân hàng',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildBankWalletView(banks: wallets['bank'] ?? []),
                    const SizedBox(
                      height: 32,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Thẻ tín dụng ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildCreditWalletView(credits: wallets['credit'] ?? []),
                    const SizedBox(
                      height: 32,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Ví điện tử ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildEWalletView(eWallets: wallets['e_wallet'] ?? []),
                    const SizedBox(
                      height: 32,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Ví chứng khoán ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildStockWalletView(stocks: wallets['stock'] ?? []),
                    const SizedBox(
                      height: 32,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Tiền mặt ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    _buildCashWalletView(cashs: wallets['cash'] ?? []),
                  ],
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: Color.fromARGB(255, 255, 255, 255),
                      alignment: Alignment.center),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddWallet()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyAppIcons.add,
                        Text(
                          'Liên kết ví',
                          style: TextStyle(color: MyAppColors.gray800),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void onWalletTap({required Wallet wallet}) {
    _navigator.push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => WalletCubit(),
          child: WalletProfile(
            walletInfo: wallet,
            //   ), BlocBuilder<WalletCubit, WalletState>(
            // builder: (context, state) {
            //   context.read<WalletCubit>().getWalletTransactions(wallet.id);
            //   return
            // },
          ),
        ),
      ),
    );
  }
}
