import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/components/images/my_images.dart';
import 'package:personal_financial_management/app/components/widgets/ListViewTitle.dart';
import 'package:personal_financial_management/app/utils/assets.dart';
import 'package:personal_financial_management/app/utils/extentsions.dart';
import 'package:personal_financial_management/domain/cubits/wallet/wallet_cubit.dart';

import 'package:personal_financial_management/domain/models/wallet.dart';

class WalletProfile extends StatefulWidget {
  const WalletProfile({Key? key, required this.walletInfo}) : super(key: key);
  final Wallet walletInfo;

  @override
  State<WalletProfile> createState() => _WalletProfileState();
}

class _WalletProfileState extends State<WalletProfile> {
  @override
  Widget build(BuildContext context) {
    print(widget.walletInfo);
    context.read<WalletCubit>().getWalletTransactions(widget.walletInfo.id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyAppColors.gray050,
        iconTheme: IconThemeData.fallback(),
        titleSpacing: 0.0,
        elevation: 5,
        title: const Text("THÔNG TIN CHI TIẾT",
            style: const TextStyle(
              fontSize: 20,
              color: MyAppColors.gray700,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // wallet info
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: Image.asset(ProfileImage.walletProfile),
                    title: Text(
                      widget.walletInfo.name,
                      style: const TextStyle(
                        color: MyAppColors.gray700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: InkWell(
                        onTap: () {},
                        child: Text(widget.walletInfo.description)),
                    trailing: MyAppIcons.setting,
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Số dư',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${numberFormat.format(widget.walletInfo.amount).toString()}VNĐ",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: MyAppColors.gray800,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: _buildWalletHistory()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletHistory() {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        if (state.walletTransitions.isEmpty) {
          //return loading indicator
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text('Không có giao dịch nào gần đây'),
            ),
          );
        }
        return Expanded(
          child: Column(
            children: [
              BuildListViewTitle(
                leftTitle: 'Lịch sử giao dịch',
                rightTitle: '',
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  final element = state.walletTransitions[index];
                  return buildListTileExpense(
                    amount: element.amount.toString(),
                    title: element.categoryName,
                    subtitle: element.createdAt.toString(),
                    isOutPut: element.is_output,
                  );
                }),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemCount: state.walletTransitions.length,
              ),
            ],
          ),
        );
      },
    );
  }
}
