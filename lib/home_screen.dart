import 'package:flutter/material.dart';
import 'package:t_commerce/tabs/home_tab.dart';
import 'package:t_commerce/tabs/saved_tab.dart';
import 'package:t_commerce/tabs/profile_tab.dart';
import 'package:t_commerce/widgets/bottom_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late PageController _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: PageView(
            controller: _tabsPageController,
            children: [
              HomeTab(),
              ProfileTab(),
              SavedTab()
            ],

            onPageChanged: (num){
              setState(() {
                _selectedTab = num;
              });
            },
          )),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (num){
              _tabsPageController.animateToPage(
                  num,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic);
            },
          )
        ],
      ),
    );
  }
}