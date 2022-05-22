import 'package:flutter/material.dart';
import 'package:personal_financial_management/app/components/charts/chart_indicator/pie_chart.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/date_controller.dart';
import 'package:personal_financial_management/app/utils/extentsions.dart';

class StatisticView extends StatelessWidget {
  StatisticView({Key? key}) : super(key: key);
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // MyDatePicker(dateTime: dateTime),
                Container(
                    color: Colors.transparent,
                    height: 300,
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: const MyPieChart()),
                Expanded(
                  child: ListView.separated(
                      addAutomaticKeepAlives: true,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          onTap: () {},
                          title: const Text('Tiền ăn'),
                          trailing: Text('- ${numberFormat.format(100000)} đ'),
                        );
                      }),
                      separatorBuilder: (context, index) {
                        // if (index == 0) return Container();
                        return Divider(
                          height: 1,
                          color: MyAppColors.gray300,
                        );
                      },
                      itemCount: 10),
                )
              ],
            )),
      ),
    );
  }
}
