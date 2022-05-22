import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_financial_management/app/components/charts/chart_indicator/pie_chart.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/date_controller.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/pages/detail/detail_view.dart';
import 'package:personal_financial_management/app/routes/app_routes.dart';
import 'package:personal_financial_management/app/utils/utils.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/blocs/page_route/page_route_bloc.dart';
import 'package:personal_financial_management/domain/cubits/category/category_cubit.dart';
import 'package:personal_financial_management/domain/repositories/budget_repo.dart';
import 'package:personal_financial_management/domain/repositories/repositories.dart';
import 'package:personal_financial_management/domain/repositories/transaction_repo.dart';
import 'package:personal_financial_management/domain/repositories/user_repo.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  NavigatorState get _navigator => GlobalKeys.appNavigatorKey.currentState!;
  PageController get _pageController => GlobalKeys.pageController;
  late final UserRepository userRepository;
  late final TransactionRepository transactionRepository;
  late final BudgetRepository budgetRepository;
  late final WalletRepository walletRepository;

  DateTime? dateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactionRepository = TransactionRepository();
    budgetRepository = BudgetRepository();
    walletRepository = WalletRepository();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(const HomeSubscriptionRequested());
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return _buildTabBar();
      },
    );
  }

  // Widgets
  // TabBar
  Widget _buildTabBar() {
    late int _currentIndex = 0;
    late TextStyle _tabBarTextStyle = TextStyle(
      fontSize: 16,
    );
    late List<Widget> _tabs = [
      Tab(
        child: Text(
          'THÁNG',
          style: _tabBarTextStyle,
        ),
      ),
      Tab(
        child: Text(
          'TUẦN',
          style: _tabBarTextStyle,
        ),
      ),
      Tab(
        child: Text(
          'NGÀY',
          style: _tabBarTextStyle,
        ),
      ),
    ];
    late List<Widget> _tabViews = [
      _buildMonthTabView(),
      _buildWeekTabView(),
      _buildDayTabView(),
    ];
    void _onChangeTab(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return DefaultTabController(
      initialIndex: _currentIndex,
      length: 3,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: MyAppColors.gray500,
                    blurRadius: 15.0,
                    offset: const Offset(0.0, 0.75),
                  )
                ],
                color: MyAppColors.gray050,
              ),
              child: TabBar(
                indicatorColor: MyAppColors.accent700,
                unselectedLabelColor: MyAppColors.gray600,
                labelColor: MyAppColors.accent700,
                onTap: _onChangeTab,
                tabs: _tabs,
              ),
            ),
          ),
          body: TabBarView(
            children: _tabViews,
          )),
    );
  }

  Widget _buildMonthTabView() {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            MyDatePicker(
              dateTime: dateTime,
              filter: TransactionFilter.month,
              isShowDatePicker: false,
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return _buildIndicatorChart(
                    totalBudget: state.totalBudget.toDouble(),
                    spent: state.spent.toDouble() * -1);
              },
            ),
            _buildListViewTitle(
                leftTitle: 'LỊCH SỬ GIAO DỊCH', rightTitle: 'XEM CHI TIẾT'),
            _buildHistoryExpense(filter: 'month'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekTabView() {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyDatePicker(
              dateTime: dateTime,
              filter: TransactionFilter.week,
              isShowDatePicker: false,
            ),
            _buildListViewTitle(
                leftTitle: 'LỊCH SỬ GIAO DỊCH TUẦN NÀY', rightTitle: ""),
            _buildHistoryExpense(filter: 'week')
          ],
        ));
  }

  Widget _buildDayTabView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          MyDatePicker(
            dateTime: dateTime,
            filter: TransactionFilter.day,
            isShowDatePicker: true,
          ),
          _buildListViewTitle(
              leftTitle: 'LỊCH SỬ GIAO DỊCH HÔM NAY', rightTitle: ""),
          _buildHistoryExpense(filter: 'day')
        ],
      ),
    );
  }

  // Chart indicator
  Widget _buildIndicatorChart(
      {required double totalBudget, required double spent}) {
    return InkWell(
      onTap: () {},
      child: CircularPercentIndicator(
        addAutomaticKeepAlive: true,
        reverse: true,
        radius: 150.0,
        animation: true,
        animationDuration: 1000,
        lineWidth: 15.0,
        percent:
            (spent / totalBudget).abs() <= 1 ? (spent / totalBudget).abs() : 1,
        center: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (spent.abs() > totalBudget)
                ? const Text(
                    'Đã chi tiêu vượt quá ngân sách',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 205, 5, 5),
                    ),
                  )
                : const Text(
                    'Đã chi tiêu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyAppColors.gray600,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                '${numberFormat.format(spent.abs())} ${numberFormat.currencyName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: MyAppColors.gray800,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              child: Text(
                'Hạn mức: ${numberFormat.format(totalBudget)} ${numberFormat.currencyName}',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyAppColors.gray600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.butt,
        backgroundColor: MyAppColors.gray100,
        progressColor: MyAppColors.gray800,
      ),
    );
  }

  // History Expense
  Widget _buildListViewTitle({String leftTitle = '', String rightTitle = ''}) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: MyAppColors.gray500,
            blurRadius: 0,
            offset: const Offset(0.0, 0.75),
          )
        ],
        color: MyAppColors.white000,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(leftTitle, style: TextStyle(fontSize: 14)),
            BlocProvider(
              create: (context) => PageRouteBloc(),
              child: BlocBuilder<PageRouteBloc, PageRouteState>(
                builder: (context, state) {
                  return TextButton(
                      onPressed: () {
                        _pageController.jumpToPage(1);
                        BlocProvider.of<PageRouteBloc>(context).add(
                          const PageJumpEvent(currentPageIndex: 1),
                        );
                      },
                      child: Text(rightTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: MyAppColors.accent800,
                          )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTileExpense({
    String title = '',
    String subtitle = '',
    String amount = '',
    bool? isOutPut = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        onTap: () {},
        leading: generateCategoryIcon(title),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          "${isOutPut == true ? '-' : '+'}${numberFormat.format(int.parse(amount))}",
          style: TextStyle(
            color: isOutPut == true ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryExpense({String filter = ''}) {
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        // buildWhen: (previous, current) =>
        //     previous.transactionMap![filter] != current.transactionMap![filter],
        builder: (context, state) {
          if (state.transactionMap![filter] == null) {
            return const Center(
              child: Text('Không có giao dịch nào'),
            );
          }
          if (state.transactionMap![filter]!.isEmpty) {
            return const Center(
              child: Text('Không có giao dịch nào'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                color: MyAppColors.gray600,
              );
            },
            itemBuilder: (context, index) {
              final element = state.transactionMap![filter]!.elementAt(index);
              return _buildListTileExpense(
                title: element.categoryName,
                subtitle:
                    "${element.createdAt.day}/${element.createdAt.month.toString().padLeft(2, '0')}/${element.createdAt.year}",
                amount: element.amount.toString(),
                isOutPut: element.is_output,
              );
            },
            itemCount: state.transactionMap![filter]!.length,
          );
        },
      ),
    );
  }
}
