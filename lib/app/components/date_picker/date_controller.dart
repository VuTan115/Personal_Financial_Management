import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/utils/utils.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/cubits/date_change/date_change_cubit.dart';

class MyDatePicker extends StatefulWidget {
  MyDatePicker({Key? key, required this.dateTime}) : super(key: key);
  late DateTime? dateTime;
  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late DateTime _today;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _today = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 56),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      // show date and two buttons of arrows to choose date
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateShow(),
              _buildMonthChanger(),
            ]),
      ),
    );
  }

  Widget _buildDateShow() {
    return Expanded(
      child: InkWell(
        splashColor: MyAppColors.gray050,
        hoverColor: MyAppColors.gray050,
        onTap: () async {
          final DateTime? picked = await showMyDatePicker(
              context: context, dateTime: widget.dateTime);
          if (picked != null) {
            setState(() {
              widget.dateTime = picked;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          height: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1.toDouble()),

            //vertical alignment this child

            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_today.month.toString().padLeft(2, '0')}/${_today.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyAppColors.gray900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// build the date changer widget with two arrows
  Widget _buildDateChanger() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: MyAppIcons.chevronLeftOn,
          onPressed: () {
            setState(() {
              _today = _today.subtract(const Duration(days: 1));
            });
          },
        ),
        IconButton(
          icon: MyAppIcons.chevronRightOn,
          onPressed: () {
            setState(() {
              _today = _today.add(const Duration(days: 1));
            });
          },
        ),
      ],
    );
  }

  Widget _buildMonthChanger() {
    return BlocProvider(
      create: (context) => DateChangeCubit(),
      child: BlocBuilder<DateChangeCubit, DateChangeState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: MyAppIcons.chevronLeftOn,
                  onPressed: () {
                    // change month of today
                    setState(() {
                      _today = _today.subtract(Duration(
                          days: getDaysInMonth(_today.year, _today.month)));
                    });
                    BlocProvider.of<DateChangeCubit>(context)
                        .dateChange(newDate: _today.toString());

                    BlocProvider.of<HomeBloc>(context).add(
                      HomeSubscriptionRequestedWithFilter(
                          date: _today, filter: TransactionFilter.month),
                    );
                  }),
              IconButton(
                icon: MyAppIcons.chevronRightOn,
                onPressed: () {
                  setState(() {
                    _today = _today.add(Duration(
                        days: getDaysInMonth(_today.year, _today.month)));
                  });
                  BlocProvider.of<DateChangeCubit>(context)
                      .dateChange(newDate: _today.toString());
                  BlocProvider.of<HomeBloc>(context).add(
                    HomeSubscriptionRequestedWithFilter(
                        date: _today, filter: TransactionFilter.month),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
