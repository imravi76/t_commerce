import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {

  final String? text;
  final VoidCallback? onPressed;
  final bool? outlineBtn, isLoading;

  const CustomBtn({Key? key, this.text, this.onPressed, this.outlineBtn, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _outlineBtn = outlineBtn ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(

        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(
                  text ?? "Button",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _outlineBtn ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: _isLoading ? true : false,
              child: const Center(
                child: SizedBox(
                  height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator()
                ),
              ),
            ),
          ],
        ),

        margin: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),

        decoration: BoxDecoration(
          color: _outlineBtn ? Colors.transparent : Colors.black,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0)
        ),

        height: 65.0,

      ),
    );
  }
}
