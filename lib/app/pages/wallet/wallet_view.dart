import 'package:flutter/material.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/pages/wallet/add_wallet.dart';
import 'package:personal_financial_management/app/pages/wallet/wallet_profile.dart';
import 'package:personal_financial_management/app/routes/app_routes.dart';
import 'package:personal_financial_management/app/utils/utils.dart';
import 'package:personal_financial_management/domain/models/wallet.dart';

class WalletView extends StatefulWidget {
  WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  NavigatorState get _navigator => GlobalKeys.appNavigatorKey.currentState!;

  late final Map<String, List<Wallet>> _walletTypes = {
    "bank": <Wallet>[
      Wallet(
          id: "85",
          name: "Ngân hàng Vietcombank",
          type: "bank",
          amount: BigInt.from(65146852),
          createdAt: "",
          updatedAt: "",
          deletedAt: ""),
      Wallet(
          id: "85",
          name: "Ngân hàng BIDV",
          type: "bank",
          amount: BigInt.from(654126852),
          createdAt: "",
          updatedAt: "",
          deletedAt: "")
    ],
    "credit": <Wallet>[
      Wallet(
          id: "14",
          name: "Master Card",
          type: "credit",
          amount: BigInt.from(341226248),
          createdAt: "",
          updatedAt: "",
          deletedAt: "")
    ],
    "e_wallet": <Wallet>[
      Wallet(
          id: "75",
          name: "Ví Momo",
          type: "e_wallet",
          amount: BigInt.from(121011964),
          createdAt: "",
          updatedAt: "",
          deletedAt: "")
    ],
    "stock": <Wallet>[
      Wallet(
          id: "63",
          name: "Ví chứng khoán",
          type: "stock",
          amount: BigInt.from(962155388),
          createdAt: "",
          updatedAt: "",
          deletedAt: "")
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyAppColors.white000,
        body: _buildWalletsView(wallets: _walletTypes));
  }

  Widget _buildBankWalletView({required List<Wallet> banks}) {
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
                          subtitle: Text(e.amount.toString()),
                          trailing: Text(
                              "${numberFormat.format(e.amount.toInt())} VND"),
                        ),
                      ))
                  .toList()),
        )
      ],
    );
  }

  Widget _buildCreditWalletView({required List<Wallet> credits}) {
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
                      subtitle: Text(e.amount.toString()),
                      trailing:
                          Text("${numberFormat.format(e.amount.toInt())} VND"),
                    )))
                .toList()),
      )
    ]);
  }

  Widget _buildEWalletView({required List<Wallet> eWallets}) {
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
                        subtitle: Text(e.amount.toString()),
                        trailing: Text(
                            "${numberFormat.format(e.amount.toInt())} VND"),
                      ),
                    ))
                .toList()),
      )
    ]);
  }

  Widget _buildStockWalletView({required List<Wallet> stocks}) {
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
                      subtitle: Text(e.amount.toString()),
                      trailing:
                          Text("${numberFormat.format(e.amount.toInt())} VND"),
                    )))
                .toList()),
      )
    ]);
  }

  Widget _buildWalletsView({required Map<String, List<Wallet>> wallets}) {
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
        builder: (context) => WalletProfile(
          walletInfo: wallet,
        ),
      ),
    );
  }
}
