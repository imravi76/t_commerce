import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart_page.dart';
import '../constants.dart';

class CustomActionBar extends StatelessWidget {

  final String? title;
  final bool? hasBackArrow, hasTitle, hasBackground;

  CustomActionBar({Key? key, this.title, this.hasBackArrow, this.hasTitle, this.hasBackground}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? false;
    bool _hasBackground = hasBackground ?? false;

    return Container(
      padding: const EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0
      ),

      decoration: BoxDecoration(
        gradient: _hasBackground ? LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0)
          ],
          begin: const Alignment(0, 0),
          end: const Alignment(0, 1)
        ) : null
      ),

      child: Row(
        children: [

          if(_hasBackArrow)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                child: const Image(
                  image: AssetImage(
                    "assets/images/back_arrow.png"
                  ),
                  width: 16.0,
                  height: 16.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)
                ),
                width: 42.0,
                height: 42.0,
                alignment: Alignment.center,
              ),
            ),

          if(_hasTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.boldHeading,
            ),

          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => const CartPage()
              )
              );
            },
            child: Container(
              child: FutureBuilder<int>(
                future: getCartItemCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final cartItemCount = snapshot.data ?? 0;
                    return Text(
                      "$cartItemCount",
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
                    );
                  }
                },
              ),
              width: 42.0,
              height: 42.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _hasBackArrow ? Colors.deepOrange : Colors.black,
                borderRadius: BorderRadius.circular(8.0)
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Future<int> getCartItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    final cartProductIds = prefs.getStringList('cartProductIds') ?? [];
    return cartProductIds.length;
  }

}
