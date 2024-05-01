
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:t_commerce/widgets/custom_btn.dart';
import 'package:t_commerce/widgets/custom_input.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _registerFormLoading = false;

  String _registerEmail = "";
  String _registerPassword = "";
  String _registerName = "";
  String _registerPhoto = "https://picsum.photos/800";

  late FocusNode _passwordFocusNode;

  @override
  void initState(){
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _alertDialogBuilder( String error) async{
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

  Future<String?> _createAccount() async{
    final url = Uri.parse('https://api.escuelajs.co/api/v1/users/');
    final response = await http.post(
      url,
      body: json.encode({
        'name': _registerName,
        'email': _registerEmail,
        'password': _registerPassword,
        'avatar': _registerPhoto,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);

      return ('User created successfully');

    } else {
      // Error creating user
      return ('Failed to create user: ${response.statusCode}');
      // You can display an error message to the user here
    }
  }

  void _submitForm() async{
    setState(() {
      _registerFormLoading = true;
    });

    String? _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null){
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoading = false;
      });
    } else{
      Navigator.pop(context);
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
                    "Welcome User\nSign Up for new Account",
                    style: Constants.regularHeading,
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 24.0),
                ),

                Column(
                  children: [

                    CustomInput(
                      hints: "Name...",
                      onChanged: (value){
                        _registerName = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    CustomInput(
                      hints: "Email...",
                      onChanged: (value){
                        _registerEmail = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    CustomInput(
                      hints: "Password...",
                      onChanged: (value){
                        _registerPassword = value;
                      },
                      onSubmitted: (value){
                        _submitForm();
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                    ),

                    CustomBtn(
                        text: "Sign Up",
                        onPressed: () {
                          //_alertDialogBuilder();
                          _submitForm();
                        },

                        isLoading: _registerFormLoading,
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0
                  ),
                  child: CustomBtn(
                    text: "Already have Account? Login Here!",
                    outlineBtn: true,

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )

              ],
            ),
          ),
        ));
  }

}
