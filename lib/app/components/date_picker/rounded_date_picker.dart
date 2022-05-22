import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';

Future<DateTime?> showMyDatePicker(
    {required BuildContext context, required DateTime? dateTime}) async {
  DateTime? newDateTime = await showRoundedDatePicker(
      context: context,
      barrierDismissible: true,
      height: MediaQuery.of(context).size.height * 0.5,
      locale: const Locale("vi", "VN"),
      theme: ThemeData(
          primarySwatch: const MaterialColor(
        0xFFFFFFFF,
        <int, Color>{
          50: Color(0xFFFFFFFF),
          100: Color(0xFFFFFFFF),
          200: Color(0xFFFFFFFF),
          300: Color(0xFFFFFFFF),
          400: Color(0xFFFFFFFF),
          500: Color(0xFFFFFFFF),
          600: Color(0xFFFFFFFF),
          700: Color(0xFFFFFFFF),
          800: Color(0xFFFFFFFF),
          900: Color(0xFFFFFFFF),
        },
      )),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleDayButton: const TextStyle(
          fontSize: 24,
          color: MyAppColors.gray900,
        ),
        textStyleYearButton: const TextStyle(
          fontSize: 24,
          color: MyAppColors.gray900,
        ),
        textStyleDayHeader: const TextStyle(
          fontSize: 18,
          color: MyAppColors.gray900,
        ),
        textStyleCurrentDayOnCalendar: const TextStyle(
            fontSize: 16,
            color: MyAppColors.gray900,
            fontWeight: FontWeight.bold),
        textStyleDayOnCalendar: const TextStyle(
          fontSize: 14,
          color: MyAppColors.gray900,
        ),
        textStyleDayOnCalendarSelected: const TextStyle(
          fontSize: 16,
          color: MyAppColors.white000,
        ),
        textStyleDayOnCalendarDisabled: TextStyle(
            fontSize: 24, color: MyAppColors.gray900.withOpacity(0.1)),
        textStyleMonthYearHeader: const TextStyle(
            decorationStyle: TextDecorationStyle.solid,
            fontSize: 20,
            color: MyAppColors.gray900,
            fontWeight: FontWeight.bold),
        paddingDatePicker: const EdgeInsets.all(0),
        paddingMonthHeader: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        paddingActionBar: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        paddingDateYearHeader: const EdgeInsets.all(14),
        sizeArrow: 30,
        colorArrowNext: MyAppColors.accent700,
        colorArrowPrevious: MyAppColors.accent700,
        textStyleButtonPositive: const TextStyle(
          fontSize: 18,
          color: MyAppColors.accent800,
        ),
        textStyleButtonNegative: const TextStyle(
          fontSize: 18,
          color: MyAppColors.accent800,
        ),
        decorationDateSelected: const BoxDecoration(
          color: MyAppColors.accent800,
          shape: BoxShape.circle,
        ),
        backgroundPicker: MyAppColors.white000,
        backgroundActionBar: MyAppColors.white000,
        backgroundHeaderMonth: MyAppColors.white000,
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        textStyleYear:
            const TextStyle(fontSize: 40, color: MyAppColors.gray800),
        textStyleYearSelected: const TextStyle(
            fontSize: 56,
            color: MyAppColors.gray800,
            fontWeight: FontWeight.bold),
        heightYearRow: 100,
        backgroundPicker: MyAppColors.white000,
      ));

  if (newDateTime != null) {
    return newDateTime.add(Duration(hours: 1));
  }

  return DateTime.now();
}
