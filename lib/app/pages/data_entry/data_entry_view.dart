import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_financial_management/app/components/categories_selector/CategoriesSelector.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/date_picker/rounded_date_picker.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/utils/extentsions.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/cubits/transaction/transaction_cubit_cubit.dart';
import 'package:personal_financial_management/domain/models/transaction.dart';

class DataEntryView extends StatefulWidget {
  const DataEntryView({Key? key}) : super(key: key);

  @override
  State<DataEntryView> createState() => _DataEntryViewState();
}

class _DataEntryViewState extends State<DataEntryView>
    with AutomaticKeepAliveClientMixin {
  String _selectedDateTab1 = 'Chọn ngày';
  String _selectedDateTab2 = 'Chọn ngày';
  String dropdownValue = 'Ăn uống';
  late Map<String, Widget> moneyCategories;
  late TextEditingController _amountControllerTab1;
  late TextEditingController _amountControllerTab2;
  late String selectedCategory;
  late Map<String, Widget> wallets;
  late Map<String, Widget> inComeWallets;
  late Map<String, Map<String, String>> _childState;
  late Map<String, dynamic>? allWalletInfor;
  late List<Transaction>? allTransactionInfor;
  @override
  void initState() {
    super.initState();
    _amountControllerTab1 = TextEditingController();
    _amountControllerTab2 = TextEditingController();
    moneyCategories = {
      "Ăn uống": MyAppIcons.lunch,
      "Giáo dục": MyAppIcons.book,
      "Nhu yếu phẩm": MyAppIcons.toothBrush,
      "Quà cáp": MyAppIcons.gift,
      "Làm đẹp": MyAppIcons.clothes,
      "Nhà ở": MyAppIcons.key,
      "Giải trí": MyAppIcons.music,
      "Di chuyển": Icon(Icons.agriculture),
    };
    wallets = {
      "Ví điện tử": MyAppIcons.wallet,
      "Thẻ tín dụng": MyAppIcons.creditCard,
      "Tài khoản ngân hàng": MyAppIcons.bank,
      "Chứng khoán": MyAppIcons.development,
    };
    inComeWallets = {
      "Lương": MyAppIcons.wallet,
      "Đầu tư": MyAppIcons.creditCard,
      "Học bổng": MyAppIcons.bank,
      "Tiền thưởng": MyAppIcons.development,
    };
    selectedCategory = '';
    _childState = {
      'tab1': {
        'amount': '',
        'category': '',
        'wallet': '',
        'date': '',
      },
      'tab2': {
        'amount': '',
        'category': '',
        'income': '',
        'date': '',
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // state.allWallets!.values.forEach((element) {
        //   print(element);
        // });

        return _buildTabBar();
      },
    );
  }

  Widget _buildTabBar() {
    late int _currentIndex = 0;
    late TextStyle _tabBarTextStyle = TextStyle(
      fontSize: 16,
    );
    late List<Widget> _tabs = [
      Tab(
        child: Text(
          'CHI TIÊU',
          style: _tabBarTextStyle,
        ),
      ),
      Tab(
        child: Text(
          'THU NHẬP',
          style: _tabBarTextStyle,
        ),
      ),
    ];
    late List<Widget> _tabViews = [
      _buildEpenseView(),
      _buildInComeView(),
    ];
    void _onChangeTab(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return DefaultTabController(
      initialIndex: _currentIndex,
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: const BoxDecoration(
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

  Widget _buildEpenseView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _childState['tab1']!['amount'] = value;
                        });
                      },
                      controller: _amountControllerTab1,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        focusColor: MyAppColors.accent800,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyAppColors.accent800, width: 1)),
                        labelText: 'Số tiền',
                        hintText: 'Nhập số tiền',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 26),
                          child: MyAppIcons.vnd,
                        ),
                      ),
                    ),
                    CateGoriesSeletor(
                      categories: moneyCategories,
                      parentKey: 'tab1',
                      parentCallback: callBack,
                      categoryType: 'category',
                    ),
                    Text(selectedCategory),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state.allWallets!.isEmpty)
                          return CateGoriesSeletor(categories: {});

                        // set default wallet and category
                        allWalletInfor = state.allWallets;
                        allTransactionInfor = state.allTransactions;
                        // _childState['tab1']!['wallet'] =
                        //     allWalletInfor!.values.first[0].name;
                        // _childState['tab2']!['income'] =
                        //     inComeWallets.keys.first;
                        // _childState['tab1']!['category'] = 'Ăn uống';
                        // _childState['tab2']!['category'] = 'Ăn uống';

                        return CateGoriesSeletor(
                          categories: _mapWalletToCateGories(state.allWallets!),
                          parentCallback: callBack,
                          parentKey: 'tab1',
                          categoryType: 'wallet',
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: MyAppColors.gray600),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: InkWell(
                        onTap: () {
                          _selectDate(context: context, key: "tab1");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 20.0),
                                child: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  tooltip: 'Chọn ngày',
                                  onPressed: () {
                                    _selectDate(context: context, key: "tab1");
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(_selectedDateTab1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: MyAppColors.accent800,
                      alignment: Alignment.center),
                  onPressed: onTab1Tap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'LƯU',
                          style: TextStyle(
                            color: MyAppColors.white000,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInComeView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      onChanged: (value) =>
                          _childState['tab2']!['amount'] = value,
                      controller: _amountControllerTab2,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        focusColor: MyAppColors.accent800,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyAppColors.accent800, width: 1)),
                        labelText: 'Số tiền',
                        hintText: 'Nhập số tiền',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 26),
                          child: MyAppIcons.vnd,
                        ),
                      ),
                    ),
                    CateGoriesSeletor(
                      categories: moneyCategories,
                      parentKey: 'tab2',
                      parentCallback: callBack,
                      categoryType: 'category',
                    ),
                    Text(selectedCategory),
                    CateGoriesSeletor(
                      categories: inComeWallets,
                      parentKey: 'tab2',
                      parentCallback: callBack,
                      categoryType: 'income',
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: MyAppColors.gray600),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: InkWell(
                        onTap: () {
                          _selectDate(context: context, key: 'tab2');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 20.0),
                                child: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  tooltip: 'Chọn ngày',
                                  onPressed: () {
                                    _selectDate(context: context, key: 'tab2');
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(_selectedDateTab2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: MyAppColors.accent800,
                      alignment: Alignment.center),
                  onPressed: onTab2Tap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'LƯU',
                          style: TextStyle(
                            color: MyAppColors.white000,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  int convertInput(String value) {
    //format value to VND currency
    numberFormat.format(int.parse(value));
    return int.parse(value);
  }

  Future<void> _selectDate(
      {required BuildContext context, String key = ''}) async {
    final DateTime? day =
        await showMyDatePicker(context: context, dateTime: DateTime.now());
    if (day != null) //if the user has selected a date
    {
      if (key == 'tab1') {
        setState(() {
          _selectedDateTab1 = DateFormat.yMMMMd("vi_VN").format(day);
          _childState[key]!.update('date', (_) => day.toString());
        });
      } else {
        setState(() {
          _selectedDateTab2 = DateFormat.yMMMMd("vi_VN").format(day);
          _childState[key]!.update('date', (_) => day.toString());
        });
      }
    }
  }

  void callBack(childState) {
    print('childState: $childState');
    switch (childState['parentKey']) {
      case 'tab1':
        setState(() {
          _childState['tab1']!
              .update(childState['selectorType'], (_) => childState['value']);
        });
        break;
      case 'tab2':
        setState(() {
          _childState['tab2']!
              .update(childState['selectorType'], (_) => childState['value']);
        });
        break;
    }
    print('_childState: $_childState');
  }

  Map<String, Widget> _mapWalletToCateGories(Map<String, dynamic> wallets) {
    List data = (wallets.values.map((e) {
      switch (e[0].type) {
        case 'bank':
          return "${e[0]!.name}:MyAppIcon.bank";
        case 'cash':
          return "${e[0]!.name}:MyAppIcon.banknote";
        case 'credit':
          return "${e[0]!.name}:MyAppIcon.creditCard";
        case 'e_wallet':
          return "${e[0]!.name}:MyAppIcon.wallet";
        case 'stock':
          return "${e[0]!.name}:MyAppIcon.development";
      }
    })).toList();
    // convert to map<string, MyAppIcon widget>
    Map<String, Widget> result = Map<String, Widget>.fromIterable(data,
        key: (dynamic item) => item.split(':')[0],
        value: (dynamic item) {
          switch (item.split(':')[1]) {
            case 'MyAppIcon.bank':
              return MyAppIcons.bank;
            case 'MyAppIcon.banknote':
              return MyAppIcons.banknote;
            case 'MyAppIcon.creditCard':
              return MyAppIcons.creditCard;
            case 'MyAppIcon.wallet':
              return MyAppIcons.wallet;
            case 'MyAppIcon.development':
              return MyAppIcons.development;
          }
          return MyAppIcons.bank;
        });

    return result;
  }

  void onTab1Tap() {
    print(_childState['tab1']);
    if (_childState['tab1']!.containsValue('')) {
      showWarning();
      return;
    }

    context.read<TransactionCubit>().createNewTransaction(
          amount: int.parse("${_childState['tab1']!['amount']}"),
          category: ("${_childState['tab1']!['category']}"),
          wallet: "${_childState['tab1']!['wallet']}",
          created_at: DateTime.parse("${_childState['tab1']!['date']}"),
          is_output: true,
        );
  }

  void onTab2Tap() {
    print(_childState['tab2']);
    if (_childState['tab2']!.containsValue('')) {
      showWarning();
      return;
    }
    final Map<String, String> data = _childState['tab2']!;

    context.read<TransactionCubit>().createNewTransaction(
          amount: int.parse("${_childState['tab2']!['amount']}"),
          category: ("${_childState['tab2']!['category']}"),
          wallet: "${_childState['tab2']!['income']}",
          created_at: DateTime.parse("${_childState['tab2']!['date']}"),
          is_output: false,
        );
    ;
  }

  void showWarning() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: const Text('Vui lòng nhập đầy đủ thông tin'),
            actions: <Widget>[
              FlatButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
