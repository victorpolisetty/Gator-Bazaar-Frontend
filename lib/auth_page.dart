import 'package:flutter/material.dart';
import 'package:student_shopping_v1/Widgets/LoginWidget.dart';
import 'package:student_shopping_v1/Widgets/forgotPasswordWidget.dart';
import 'package:student_shopping_v1/Widgets/signup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isForgotPassword = false;
  @override
  Widget build(BuildContext context){
  if(isLogin && isForgotPassword) {
    return ForgotPasswordWidget(onClickedForgotPassword: toggleForgotPassword);
  }
  else if (isLogin){
    return LoginWidget(onClickedSignUp: toggle, onClickedForgotPassword: toggleForgotPassword);
  }
  else {
    return SignUpWidget(onClickedSignIn: toggle);
  }
  }


  void toggle() => setState(() => isLogin = !isLogin);
  void toggleForgotPassword() => setState(() => isForgotPassword = !isForgotPassword);
}
