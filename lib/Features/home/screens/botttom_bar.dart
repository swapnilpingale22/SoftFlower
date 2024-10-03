import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController pageController;

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: primaryColor2,
        border: const Border(
          top: BorderSide(
            width: 0.2,
            color: secondaryColor,
          ),
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.house,
              size: 24,
              color: _page == 0 ? textColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
            tooltip: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description_outlined,
              size: 24,
              color: _page == 1 ? textColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
            tooltip: 'Report',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.add_box_outlined,
          //     size: 24,
          //     color: _page == 2 ? textColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   tooltip: 'Add',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.favorite_outline,
          //     size: 24,
          //     color: _page == 3 ? textColor : secondaryColor,
          //   ),
          //   backgroundColor: primaryColor,
          //   tooltip: 'Notifications',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 24,
              color: _page == 2 ? textColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
            tooltip: 'Account',
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
