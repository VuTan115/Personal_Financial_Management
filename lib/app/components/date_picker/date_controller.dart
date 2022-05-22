import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/utils/utils.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';

class MyDatePicker extends StatefulWidget {
  MyDatePicker(
      {Key? key,
      required this.dateTime,
      required this.isShowDatePicker,
      required this.filter})
      : super(key: key);
  late DateTime? dateTime;
  bool isShowDatePicker;
  TransactionFilter filter;
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
    DateTime monday = _today.subtract(Duration(days: _today.weekday - 1));
    monday = DateTime(monday.year, monday.month, monday.day);
    DateTime sunday =
        _today.add(Duration(days: DateTime.daysPerWeek - _today.weekday));
    sunday = DateTime(sunday.year, sunday.month, sunday.day);
    return Expanded(
      child: InkWell(
        splashColor: MyAppColors.gray050,
        hoverColor: MyAppColors.gray050,
        onTap: (widget.isShowDatePicker)
            ? () async {
                final DateTime? picked = await showMyDatePicker(
                    context: context, dateTime: widget.dateTime);
                if (picked != null) {
                  setState(() {
                    widget.dateTime = picked;
                    _today = picked.add(const Duration(hours: 12));
                    BlocProvider.of<HomeBloc>(context).add(
                      HomeSubscriptionRequestedWithFilter(
                          date: _today, filter: widget.filter),
                    );
                  });
                }
              }
            : () {},
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
                widget.filter == TransactionFilter.month
                    ? '${_today.month.toString().padLeft(2, '0')}/${_today.year}'
                    : widget.filter == TransactionFilter.week
                        ? '${monday.day.toString().padLeft(2, '0')}/${monday.month.toString().padLeft(2, '0')}/${monday.year}' +
                            ' -> ' +
                            '${sunday.day.toString().padLeft(2, '0')}/${sunday.month.toString().padLeft(2, '0')}/${sunday.year}'
                        : '${_today.day.toString().padLeft(2, '0')}/${_today.month.toString().padLeft(2, '0')}/${_today.year}',
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
  // Widget _buildDateChanger() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       IconButton(
  //         icon: MyAppIcons.chevronLeftOn,
  //         onPressed: () {
  //           setState(() {
  //             _today = _today.subtract(const Duration(days: 1));
  //           });
  //         },
  //       ),
  //       IconButton(
  //         icon: MyAppIcons.chevronRightOn,
  //         onPressed: () {
  //           setState(() {
  //             _today = _today.add(const Duration(days: 1));
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMonthChanger() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: MyAppIcons.chevronLeftOn,
            onPressed: () {
              // change month of today
              setState(() {
                _today = (widget.filter == TransactionFilter.month)
                    ? _today.subtract(Duration(
                        days: getDaysInMonth(_today.year, _today.month)))
                    : (widget.filter == TransactionFilter.week)
                        ? _today.subtract(Duration(days: 7))
                        : _today.subtract(Duration(days: 1));
                BlocProvider.of<HomeBloc>(context).add(
                  HomeSubscriptionRequestedWithFilter(
                      date: _today, filter: widget.filter),
                );
              });
            }),
        IconButton(
          icon: MyAppIcons.chevronRightOn,
          onPressed: () {
            setState(() {
              _today = (widget.filter == TransactionFilter.month)
                  ? _today.add(
                      Duration(days: getDaysInMonth(_today.year, _today.month)))
                  : (widget.filter == TransactionFilter.week)
                      ? _today.add(Duration(days: 7))
                      : _today.add(Duration(days: 1));
              BlocProvider.of<HomeBloc>(context).add(
                HomeSubscriptionRequestedWithFilter(
                    date: _today, filter: widget.filter),
              );
            });
          },
        ),
      ],
    );
  }
}
