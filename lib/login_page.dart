import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_commerce/register_page.dart';
import 'package:t_commerce/widgets/custom_btn.dart';
import 'package:t_commerce/widgets/custom_input.dart';

import 'constants.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _loginFormLoading = false;

  String _loginEmail = "";
  String _loginPassword = "";

  late FocusNode _emailFocusNode, _passwordFocusNode;

  @override
  void initState(){
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    _emailFocusNode = FocusNode();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: const Text("Error"),
            content: Text(error),
            actions: [
              TextButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String?> _loginAccount() async{
    final url = Uri.parse('https://api.escuelajs.co/api/v1/auth/login');
    final response = await http.post(
      url,
      body: json.encode({
        'email': _loginEmail,
        'password': _loginPassword,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Login successful
      final responseData = json.decode(response.body);
      final access_token = responseData['access_token'];
      final refresh_token = responseData['refresh_token'];
      // Store token in shared preferences
      await storeToken(access_token, refresh_token);
      // Navigate to the next screen (e.g., HomeScreen)
      return null;
    } else {
      // Login failed
      return ('Login failed: ${response.statusCode}');
      // You can display an error message to the user here
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });

    String? _loginAccountFeedback = await _loginAccount();
    if(_loginAccountFeedback != null){
      _alertDialogBuilder(_loginAccountFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }else{
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => SplashScreen()),ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              child: const Text(
                "Welcome User\nLogin to your Account",
                style: Constants.regularHeading,
                textAlign: TextAlign.center,
              ),
              padding: const EdgeInsets.only(top: 24.0),
            ),

            Column(
              children: [

                CustomInput(
                  hints: "Email...",
                  onChanged: (value){
                    _loginEmail = value;
                  },
                  onSubmitted: (value){
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                  isPasswordField: false,
                  focusNode: _emailFocusNode,
                ),

                CustomInput(
                  hints: "Password...",
                  onChanged: (value){
                    _loginPassword = value;
                  },
                  onSubmitted: (value){
                    _submitForm();
                  },
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                ),

                CustomBtn(
                    text: "Login",
                    onPressed: () {
                      _submitForm();
                    },

                    isLoading: _loginFormLoading,
                )
              ],
            ),

            Padding(

              padding: const EdgeInsets.only(
                bottom: 16.0
              ),

              child: CustomBtn(
                text: "Create new Account",
                outlineBtn: true,

                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()));
                },
              ),
            )

          ],
        ),
      ),
    )
    );
  }

  Future<void> storeToken(String access_token, String refresh_token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access_token);
    await prefs.setString('refresh_token', refresh_token);
  }
}
