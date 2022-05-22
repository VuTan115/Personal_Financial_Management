import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/domain/cubits/wallet/wallet_cubit.dart';

/**amount, name, type, user_id, description */

class WalletInfoInput extends StatefulWidget {
  WalletInfoInput({
    Key? key,
    required this.name,
    required this.type,
  }) : super(key: key);
  final String name;
  final String type;
  late num? amount;
  late String description;
  @override
  State<WalletInfoInput> createState() => _WalletInfoInputState();
}

class _WalletInfoInputState extends State<WalletInfoInput> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "TẠO VÍ ${widget.name.toUpperCase()}",
          style: TextStyle(color: MyAppColors.gray700),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => WalletCubit(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: BoxConstraints.tightFor(height: 400),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
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
                              borderSide: BorderSide(
                                  color: MyAppColors.accent800, width: 1)),
                          labelText: 'Số tiền',
                          hintText: 'Nhập số tiền',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 26),
                            child: MyAppIcons.vnd,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _descriptionController,
                        minLines: 5,
                        maxLines: 10,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          focusColor: MyAppColors.accent800,
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: MyAppColors.accent800, width: 1)),
                          labelText: 'Mô tả',
                          hintText: 'Thêm mô tả cho ví...',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 26),
                            child: MyAppIcons.discussion,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 4,
                          primary: MyAppColors.accent800,
                          alignment: Alignment.center),
                      onPressed: () {
                        if (_amountController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Cảnh báo!',
                                      style: TextStyle(
                                          color: MyAppColors.accent800,
                                          fontWeight: FontWeight.bold)),
                                  content: const Text(
                                      'Bạn chưa nhập số tiền cho ví rồi!!'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Đóng'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                          return;
                        }

                        BlocProvider.of<WalletCubit>(context).createNewWallet(
                          name: widget.name,
                          type: widget.type,
                          amount: int.parse(_amountController.text),
                          description: _descriptionController.text,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'TẠO VÍ',
                              style: TextStyle(
                                color: MyAppColors.white000,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
