import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';

/**amount, name, type, user_id, description */

class WalletInfoInput extends StatefulWidget {
  const WalletInfoInput({Key? key}) : super(key: key);

  @override
  State<WalletInfoInput> createState() => _WalletInfoInputState();
}

class _WalletInfoInputState extends State<WalletInfoInput> {
  late final TextEditingController _amountController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            focusColor: MyAppColors.accent800,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: MyAppColors.accent800, width: 1)),
            labelText: 'Số tiền',
            hintText: 'Nhập số tiền',
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 26),
              child: MyAppIcons.vnd,
            ),
          ),
        ),
      ]),
    );
  }
}
