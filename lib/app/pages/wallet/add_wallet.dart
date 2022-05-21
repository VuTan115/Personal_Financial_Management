import 'package:flutter/material.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/utils/extentsions.dart';

class AddWallet extends StatelessWidget {
  const AddWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: const Text(
          'Liên kết ví',
          style: TextStyle(color: MyAppColors.gray700),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildListItem(walletName: "Tài khoản ngân hàng", walletType: "bank"),
          _buildListItem(walletName: "Tài khoản tiền mặt", walletType: "cash"),
          _buildListItem(walletName: "Thẻ tín dụng", walletType: "credit"),
          _buildListItem(walletName: "Ví điện tử", walletType: "e_wallet"),
          _buildListItem(walletName: "Chứng khoán", walletType: "stock"),
        ],
      )),
    );
  }

  Widget _buildListItem(
      {required String walletName, required String walletType}) {
    return Container(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(width: 1.0, color: MyAppColors.gray400)),
      ),
      child: ListTile(
        onTap: () {},
        leading: generateWalletIcon(walletType),
        title: Text(walletName),
      ),
    );
  }
}
