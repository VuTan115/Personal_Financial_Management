import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/utils/assets.dart';
import 'package:personal_financial_management/app/utils/global_key.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';

class MyBottomNavigator extends StatefulWidget {
  const MyBottomNavigator({
    Key? key,
    required this.pageController,
    required this.currentIndex,
  }) : super(key: key);
  final PageController pageController;
  final int currentIndex;
  @override
  State<MyBottomNavigator> createState() => _MyBottomNavigatorState();
}

class _MyBottomNavigatorState extends State<MyBottomNavigator> {
  late final BottomNavigationBarItem homePage;

  late final BottomNavigationBarItem detailsPage;

  late final BottomNavigationBarItem inputPage;

  late final BottomNavigationBarItem statisticPage;

  late final BottomNavigationBarItem walletPage;
  late int _currentIndex;
  @override
  void initState() {
    homePage = BottomNavigationBarItem(
      icon: MyAppIcons.home,
      activeIcon: MyAppIcons.homeActive,
      label: 'Trang chủ',
    );
    detailsPage = BottomNavigationBarItem(
      icon: MyAppIcons.details,
      activeIcon: MyAppIcons.detailsActive,
      label: 'Chi tiết',
    );
    inputPage = BottomNavigationBarItem(
      icon: MyAppIcons.create,
      activeIcon: MyAppIcons.createActive,
      label: 'Nhập',
    );
    statisticPage = BottomNavigationBarItem(
      icon: MyAppIcons.pieChart,
      activeIcon: MyAppIcons.pieChartActive,
      label: 'Thống kê',
    );
    walletPage = BottomNavigationBarItem(
      icon: MyAppIcons.wallet,
      activeIcon: MyAppIcons.walletActive,
      label: 'Ví',
    );
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          key: GlobalKeys.bottomBarKey,
          currentIndex: _currentIndex,
          elevation: 0.1,
          unselectedItemColor: MyAppColors.gray500,
          selectedItemColor: MyAppColors.accent800,
          backgroundColor: MyAppColors.gray100,
          mouseCursor: MaterialStateMouseCursor.clickable,
          showUnselectedLabels: true,
          iconSize: 24,
          type: BottomNavigationBarType.fixed,
          items: [
            homePage,
            detailsPage,
            inputPage,
            statisticPage,
            walletPage,
          ],
          onTap: _handleBarItemTap,
        ),
      ),
    );
  }

  void _handleBarItemTap(int index) {
    setState(() {
      _currentIndex = index;
      widget.pageController.jumpToPage(index);
    });
  }
}
