// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_financial_management/app/pages/data_entry/data_entry_view.dart';
import 'package:personal_financial_management/app/pages/detail/detail_view.dart';
import 'package:personal_financial_management/app/pages/home/home_view.dart';
import 'package:personal_financial_management/app/pages/login_page.dart';
import 'package:personal_financial_management/app/pages/wallet/add_wallet.dart';
import 'package:personal_financial_management/app/pages/wallet/wallet_view.dart';
import 'package:personal_financial_management/test.dart';

void main() {
  testWidgets('Login page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Test()));
  });
  testWidgets('Detail page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Test()));
  });
  testWidgets('Statistic page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.text('Đăng nhập'), findsWidgets);
  });
  testWidgets('Login page', (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(home: DetailView()));
  });
  testWidgets('Data Entry page', (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(home: DataEntryView()));
  });
  testWidgets('Home page', (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(home: HomeView()));
  });
  testWidgets('Wallet page', (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(home: WalletView()));
  });
  testWidgets('AddWallet page', (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(home: AddWallet()));
  });
}
