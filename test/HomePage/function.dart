// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_financial_management/app/pages/detail/detail_view.dart';
import 'package:personal_financial_management/app/pages/login_page.dart';

void main() {
  testWidgets('Login page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DetailView()));
    expect(find.text('Đăng nhập'), findsNothing);
  });
}
