import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class BottomTabs extends StatefulWidget {

  final int? selectedTab;
  final Function(int)? tabPressed;

  const BottomTabs({Key? key, this.selectedTab, this.tabPressed}) : super(key: key);

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {

  int? _selectedTab = 0;

  @override
  Widget build(BuildContext context) {

    _selectedTab = widget.selectedTab ?? 0;

    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomTabBtn(
              imagePath: "assets/images/tab_home.png",
              onPressed: (){
                widget.tabPressed!(0);
              },
              selected: _selectedTab == 0 ? true : false,
            ),
            BottomTabBtn(
              imagePath: "assets/images/tab_person.png",
              onPressed: (){
                widget.tabPressed!(1);
              },
              selected: _selectedTab == 1 ? true : false,
            ),
            BottomTabBtn(
              imagePath: "assets/images/tab_saved.png",
              onPressed: (){
                widget.tabPressed!(2);
              },
              selected: _selectedTab == 2 ? true : false,
            ),
            BottomTabBtn(
              imagePath: "assets/images/tab_logout.png",
              onPressed: (){
                clearTokensAndNavigate(context);
              },
              selected: _selectedTab == 3 ? true : false,
            ),
          ],
        ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1.0,
            blurRadius: 30.0
          )
        ]
      ),
    );
  }

  Future<void> clearTokensAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SplashScreen()),ModalRoute.withName('/'));

  }
}

class BottomTabBtn extends StatelessWidget {

  final String? imagePath;
  final bool? selected;
  final VoidCallback? onPressed;

  const BottomTabBtn({Key? key, this.imagePath, this.selected, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,

      child: Container(

        child: Image(
          image: AssetImage(
            imagePath ?? "assets/images/tab_home.png"
          ),
          width: 22.0,
          height: 22.0,
          color: _selected ? Colors.deepOrange : Colors.black,
        ),

        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _selected ? Colors.deepOrange : Colors.transparent,
              width: 3.0,
            )
          )
        ),

        padding: const EdgeInsets.symmetric(
          vertical: 28.0,
          horizontal: 24.0,
        ),
      ),
    );
  }
}
