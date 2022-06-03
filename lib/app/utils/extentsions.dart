//format number according to #.##0.00 format
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';

final NumberFormat numberFormat = NumberFormat.currency(
  locale: 'vi-VN',
  symbol: '',
  decimalDigits: 0,
  customPattern: '#,##0',
);

// get number of days in a specific month
int getDaysInMonth(int year, int month) {
  return DateTime(year, month + 1).difference(DateTime(year, month)).inDays;
}

Widget generateCategoryIcon(String name) {
  switch (name) {
    case 'Xăng xe':
      return MyAppIcons.build;
    case "Nhu yếu phẩm":
      return MyAppIcons.toothBrush;
    case "Giáo dục":
      return MyAppIcons.book;
    case "Giải trí":
      return MyAppIcons.music;
    case "Quà cáp":
      return MyAppIcons.gift;
    case "Làm đẹp":
      return MyAppIcons.clothes;
    case "Nhà ở":
      return MyAppIcons.key;
    case "Di chuyển":
      return const Icon(Icons.agriculture);
    case "Ăn uống":
      return MyAppIcons.lunch;
    case "Thưởng":
      return const Icon(Icons.attach_money);
    case "Lương":
      return const Icon(Icons.cases_sharp);
    default:
      return MyAppIcons.priceTag;
  }
}

Widget generateWalletIcon(String name) {
  switch (name) {
    case 'bank':
      return MyAppIcons.bank;
    case "stock":
      return MyAppIcons.development;
    case "e_wallet":
      return MyAppIcons.smartPhone;
    case "credit":
      return MyAppIcons.creditCard;
    case "cash":
      return MyAppIcons.banknote;

    default:
      return const Icon(Icons.cases_sharp);
  }
}

Widget buildListTileExpense({
  String title = '',
  String subtitle = '',
  String amount = '',
  bool? isOutPut = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ListTile(
      onTap: () {},
      leading: generateCategoryIcon(title),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        "${isOutPut == true ? '-' : '+'}${numberFormat.format(int.parse(amount))}",
        style: TextStyle(
          color: isOutPut == true ? Colors.red : Colors.green,
        ),
      ),
    ),
  );
}

Widget buildHistoryExpense() {
  return Expanded(
    child: BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.transactions!.isEmpty) {
          return const Center(
            child: Text('Không có giao dịch nào'),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              color: MyAppColors.gray600,
            );
          },
          itemBuilder: (context, index) {
            final element = state.transactions!.elementAt(index);
            return buildListTileExpense(
              title: element.categoryName,
              subtitle:
                  "${element.createdAt.day}/${element.createdAt.month.toString().padLeft(2, '0')}/${element.createdAt.year}",
              amount: element.amount.toString(),
              isOutPut: element.is_output,
            );
          },
          itemCount: state.transactions!.length,
        );
      },
    ),
  );
}

Color generateCategoryColor(String name) {
  switch (name) {
    case 'Xăng xe':
      return Colors.orange;
    case "Nhu yếu phẩm":
      return Colors.green;
    case "Giáo dục":
      return Colors.blue;
    case "Giải trí":
      return Colors.purple;
    case "Quà cáp":
      return Colors.yellow;
    case "Làm đẹp":
      return Colors.pink;
    case "Nhà ở":
      return Colors.red;
    case "Di chuyển":
      return Colors.green;
    case "Ăn uống":
      return Colors.orange;
    case "Thưởng":
      return Colors.yellow;
    case "Lương":
      return Colors.blue;
    default:
      return Colors.pink;
  }
}
