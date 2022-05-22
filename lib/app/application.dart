import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:personal_financial_management/app/pages/login_page.dart';
import 'package:personal_financial_management/app/pages/main_page.dart';
import 'package:personal_financial_management/app/pages/welcome_page.dart';
import 'package:personal_financial_management/app/routes/app_routes.dart';
import 'package:personal_financial_management/app/utils/global_key.dart';
import 'package:personal_financial_management/domain/blocs/auth_bloc/authentication_bloc.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/repositories/budget_repo.dart';
import 'package:personal_financial_management/domain/repositories/category_repo.dart';
import 'package:personal_financial_management/domain/repositories/repositories.dart';
import 'package:personal_financial_management/domain/repositories/user_repo.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthenticationRepository authenticationRepository;
  late final UserRepository userRepository;
  late final TransactionRepository transactionRepository;
  late final BudgetRepository budgetRepository;
  late final WalletRepository walletRepository;
  late final CategoryRepository categoryRepository;
  NavigatorState get _navigator => GlobalKeys.appNavigatorKey.currentState!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authenticationRepository = AuthenticationRepository();
    userRepository = UserRepository();
    transactionRepository = TransactionRepository();
    budgetRepository = BudgetRepository();
    walletRepository = WalletRepository();
    categoryRepository = CategoryRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: transactionRepository),
          RepositoryProvider.value(value: budgetRepository),
          RepositoryProvider.value(value: walletRepository),
          RepositoryProvider.value(value: categoryRepository),
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
                    walletRepository: walletRepository)
                  ..add(const HomeSubscriptionRequested()))
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
              return BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushNamedAndRemoveUntil(
                        AppRoute.home,
                        (Route<dynamic> route) => false,
                      );
                      break;
                    case AuthenticationStatus.authenticated:
                      _navigator.pushNamedAndRemoveUntil(
                        AppRoute.home,
                        (Route<dynamic> route) => false,
                        arguments: state.user,
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: child,
              );
            },
          ),
        ));
  }
}
