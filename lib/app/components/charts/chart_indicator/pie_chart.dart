import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/utils/assets.dart';
import 'package:personal_financial_management/app/utils/extentsions.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({
    Key? key,
    required this.children,
  }) : super(key: key);
  final List<Widget> children;
  @override
  State<StatefulWidget> createState() => MyPieChartState();
}

class MyPieChartState extends State {
  int touchedIndex = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 100,
              startDegreeOffset: -90,
              centerSpaceColor: MyAppColors.gray050,
              sections: showingSections(),
            ),
          ),
          Center(
              child: Container(
            constraints: const BoxConstraints(
              maxWidth: 200,
              maxHeight: 200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ngân sách',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: MyAppColors.gray600),
                ),
                Text(
                  numberFormat.format(30000000),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: MyAppColors.gray900,
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  // final dummyData =
  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 64.0 : 40.0;
      final widgetSize = isTouched ? 28.0 : 36.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: MyAppColors.gray700,
            value: 40,
            title: isTouched ? '40%' : '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyAppColors.white000,
            ),
            badgeWidget: _Badge(
              SocialIcon.smartPhone,
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: isTouched ? 1.07 : .5,
          );
        case 1:
          return PieChartSectionData(
            color: MyAppColors.gray500,
            value: 30,
            title: isTouched ? '30%' : '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyAppColors.white000,
            ),
            badgeWidget: _Badge(
              FinancialIcon.penny,
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: isTouched ? 1.07 : .5,
          );
        case 2:
          return PieChartSectionData(
            color: MyAppColors.gray300,
            value: 30,
            title: isTouched ? '30%' : '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: MyAppColors.white000,
            ),
            badgeWidget: _Badge(
              FinancialIcon.bankBuilding,
              size: widgetSize,
              borderColor: Colors.transparent,
            ),
            badgePositionPercentageOffset: isTouched ? 1.07 : .5,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
