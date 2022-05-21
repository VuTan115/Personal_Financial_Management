// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_financial_management/app/application.dart';
import 'package:personal_financial_management/app/pages/login_page.dart';
import 'package:personal_financial_management/app/routes/app_routes.dart';
import 'package:personal_financial_management/app/utils/global_key.dart';
import 'package:personal_financial_management/domain/blocs/auth_bloc/authentication_bloc.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/repositories/budget_repo.dart';
import 'package:personal_financial_management/domain/repositories/repositories.dart';
import 'package:personal_financial_management/domain/repositories/user_repo.dart';

Widget returnTestable(Widget widget) {
  AuthenticationRepository authenticationRepository =
      new AuthenticationRepository();
  UserRepository userRepository = new UserRepository();
  TransactionRepository transactionRepository = new TransactionRepository();
  BudgetRepository budgetRepository = new BudgetRepository();
  WalletRepository walletRepository = new WalletRepository();
  return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: budgetRepository),
        RepositoryProvider.value(value: walletRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: authenticationRepository,
                  userRepository: userRepository)),
          BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(
                  transactionRepository: transactionRepository,
                  budgetRepository: budgetRepository,
                  walletRepository: walletRepository))
        ],
        child: MaterialApp(
          // key: _navigatorKey,
          //only show on recently opened app
          title: 'Personal Financial Management',
          debugShowMaterialGrid: false,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            GlobalCupertinoLocalizations
                .delegate, // Add global cupertino localiztions.
          ],
          supportedLocales: const [
            Locale("vi", "VI"),
            Locale("en", "US"),
          ],
          onGenerateRoute: AppRoute.generateRoute,
          // home: MainPage(),
          navigatorKey: GlobalKeys.appNavigatorKey,
          navigatorObservers: <NavigatorObserver>[routeObserver],

          builder: (context, child) {
            return widget;
          },
        ),
      ));
}

void main() {
  testWidgets('Check full display', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(returnTestable(LoginPage()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
