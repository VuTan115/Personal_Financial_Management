import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_financial_management/app/components/charts/chart_indicator/pie_chart.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/date_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticBloc()
        ..add(StatisticLoadData(
          dateTime: DateTime.now(),
        )),
      child: BlocBuilder<StatisticBloc, StatisticState>(
        // buildWhen: (previous, current) => previous.status != current.status,
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
                          amountChart: Text(
                            "${numberFormat.format(dummyData['totalBudget'])}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: MyAppColors.gray900,
                              overflow: TextOverflow.clip,
                            ),
                          ),
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
                                print(element['_id']);
                              },
                              leading: generateCategoryIcon(element['name']),
                              title: Text(element['name'] ?? 'Danh mục tự do'),
                              subtitle: Text(element['budget'] == 0
                                  ? 'Chưa chi tiêu'
                                  : "Đã tiêu ${numberFormat.format(element['spent'])}"),
                              trailing: Text(
                                  '${numberFormat.format(element['budget'])} đ'),
                            );
                          }),
                          separatorBuilder: (context, index) {
                            // if (index == 0) return Container();
                            return Divider(
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
}
