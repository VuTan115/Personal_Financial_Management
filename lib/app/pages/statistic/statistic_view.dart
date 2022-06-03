import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_financial_management/app/components/charts/chart_indicator/pie_chart.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/date_controller.dart';
import 'package:personal_financial_management/app/components/date_picker/rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/utils/extentsions.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/blocs/statistic/statistic_bloc.dart';

class StatisticView extends StatefulWidget {
  StatisticView({Key? key}) : super(key: key);

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> {
  DateTime? dateTime;

//   {
  Map<String, dynamic> dummyData = {
    "totalBudget": 0,
    "categories": [
      {
        "id": "1",
        "name": "Ăn uống",
        "budget": 0,
        "spent": 0,
      },
      {
        "id": "2",
        "name": "Di chuyển",
        "budget": 0,
        "spent": 0,
      },
      {
        "id": "3",
        "name": "Giải trí",
        "budget": 0,
        "spent": 0,
      },
      {
        "id": "4",
        "name": "Mua sắm",
        "budget": 0,
        "spent": 0,
      },
      {
        "id": "5",
        "name": "Quà cáp",
        "budget": 0,
        "spent": 0,
      },
      {
        "id": "6",
        "name": "Nhu yếu phẩm",
        "budget": 0,
        "spent": 0,
      },
    ],
  };
  String _selectedDateString = 'Chọn ngày';
  late String _currentDate;
  String newTotalBudget = '';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticBloc()
        ..add(StatisticLoadData(
          dateTime: DateTime.now(),
        )),
      child: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          if (state.status == StatisticStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.data.isNotEmpty) {
            dummyData.update(
                'totalBudget', (value) => state.data['totalBudget']);
            dummyData.update('categories', (value) => state.data['categories']);
          }

          print(state.dateTime);
          _currentDate = (state.dateTime);

          if (newTotalBudget != '') {
            dummyData.update(
                'totalBudget', (value) => int.parse(newTotalBudget));
          }
          return Scaffold(
            body: Center(
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyDatePicker(
                        dateTime: dateTime,
                        filter: TransactionFilter.month,
                        isShowDatePicker: false,
                        pageKey: "statistic",
                      ),
                      Container(
                        color: Colors.white,
                        height: 300,
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: StatisticChart(
                          titleChart: Text("Ngân sách"),
                          amountChart: dummyData['totalBudget'] < 0
                              ? InkWell(
                                  onTap: () {
                                    showTotalBudgetSetter();
                                  },
                                  child: const Text(
                                    'Chưa thiết lâp',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: MyAppColors.gray900,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                )
                              : Text(
                                  numberFormat.format(dummyData['totalBudget']),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: MyAppColors.gray900,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                          totalBudget: dummyData['totalBudget'],
                          data: dummyData['categories'],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          addAutomaticKeepAlives: true,
                          itemBuilder: ((context, index) {
                            // element is map <string, dynamic>
                            // {
                            //   "id": "1",
                            //   "name": "Ă uống",
                            //   "budget": 0,
                            //   "spent": 0,
                            // },
                            final element =
                                dummyData['categories'].elementAt(index);
                            return ListTile(
                              onTap: () {
                                showCategorySetter(element['_id']);
                              },
                              leading: generateCategoryIcon(element['name']),
                              title: Text(element['name'] ?? 'Danh mục tự do'),
                              subtitle: Text(element['spent'] < 0
                                  ? 'Chưa chi tiêu'
                                  : "Đã tiêu ${numberFormat.format(element['spent'])}"),
                              trailing: element['budget'] > 0
                                  ? Text(
                                      '${numberFormat.format(element['budget'])} đ')
                                  : const Text(
                                      'Chưa thiết lập ngân sách',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 179, 80, 80)),
                                    ),
                            );
                          }),
                          separatorBuilder: (context, index) {
                            // if (index == 0) return Container();
                            return const Divider(
                              height: 1,
                              color: MyAppColors.gray300,
                            );
                          },
                          itemCount: dummyData['categories'].length,
                        ),
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  void showCategorySetter(String categoryId) {
    TextEditingController _newCategoryName = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: MyAppColors.accent700,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: MyAppColors.accent800)),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Expanded(
                    child: Form(
                      // key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _newCategoryName,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(),
                                focusColor: MyAppColors.accent800,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyAppColors.accent800,
                                        width: 1)),
                                labelText: 'Thiết lập ngân sách cho danh mục',
                                hintText: 'Nhập số tiền',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 26),
                                  child: MyAppIcons.vnd,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: BlocProvider(
                                  create: (context) => StatisticBloc(),
                                  child: BlocBuilder<StatisticBloc,
                                      StatisticState>(
                                    builder: (statisticContext, state) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 4,
                                            primary: MyAppColors.accent800,
                                            alignment: Alignment.center),
                                        onPressed: () {
                                          onCategorySave(
                                              context: statisticContext,
                                              budget: _newCategoryName.text,
                                              categoryId: categoryId);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'THIẾT LẬP',
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
                                ),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
    print(categoryId);
  }

  void onCategorySave(
      {required BuildContext context,
      required String budget,
      required String categoryId}) {
    BlocProvider.of<StatisticBloc>(context).add(
      StatisticCreateCategory(
        categoryId: categoryId,
        amount: int.parse(budget),
        dateTime: DateTime.parse(_currentDate),
      ),
    );

    // update dummyData with new data is {id:categoryId, amount:budget}
    setState(() {
      dummyData['categories'].forEach((element) {
        if (element['_id'] == categoryId) {
          element['budget'] = int.parse(budget);
        }
      });
    });
    Navigator.of(context).pop();
  }

  void showTotalBudgetSetter() {
    TextEditingController _newTotalBudget = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: MyAppColors.accent700,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: MyAppColors.accent800)),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Expanded(
                    child: Form(
                      // key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _newTotalBudget,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(),
                                focusColor: MyAppColors.accent800,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyAppColors.accent800,
                                        width: 1)),
                                labelText: 'Thiết lập ngân sách ',
                                hintText: 'Nhập số tiền',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 26),
                                  child: MyAppIcons.vnd,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: BlocProvider(
                                  create: (context) => StatisticBloc(),
                                  child: BlocBuilder<StatisticBloc,
                                      StatisticState>(
                                    builder: (statisticContext, state) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 4,
                                            primary: MyAppColors.accent800,
                                            alignment: Alignment.center),
                                        onPressed: () {
                                          onTotalBudgetSave(
                                            context: statisticContext,
                                            budget: _newTotalBudget.text,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'THIẾT LẬP',
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
                                ),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void onTotalBudgetSave({
    required BuildContext context,
    required String budget,
    // required String categoryId,
  }) {
    BlocProvider.of<StatisticBloc>(context).add(
      StatisticCreateTotalBudget(
        amount: int.parse(budget),
        dateTime: DateTime.parse(_currentDate),
      ),
    );
    setState(() {
      newTotalBudget = budget;
    });
    Navigator.of(context).pop();
  }
}
