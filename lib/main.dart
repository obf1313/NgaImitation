import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:nga/pages/loginPage.dart';
import 'package:nga/utils/resources/colors.dart';

void main() => runApp(NgaApp());

class NgaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: '仿NGA论坛',
        theme: ThemeData(
            primaryColor: MyColors.app_main,
            backgroundColor: MyColors.app_background,
            textTheme: TextTheme(
              //设置Material的默认字体样式
              body1: TextStyle(color: Colors.black54, fontSize: 14.0),
            ),
            iconTheme: IconThemeData(
              color: Colors.blue,
              size: 20.0,
            )
        ),
        home: Scaffold(
          body: LoginPage(),
        ),
      ),
    );
  }
}
