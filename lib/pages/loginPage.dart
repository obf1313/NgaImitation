import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key key }) : super( key : key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20,100,20,0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal:  20.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'NGA.CN',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '精英玩家俱乐部',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
                SizedBox(height: 25.0),
                Image.asset('assets/images/logo.png', width: 45),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    icon: Icon(Icons.person, size: 25.0, color: Colors.white),
                    hintText: '用户名',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入用户名';
                    }
                  },
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    icon: Icon(Icons.lock, size: 25.0, color: Colors.white),
                    hintText: '密码',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '请输入密码';
                    }
                  },
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 50.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: (){

                    },
                    child: Text(
                      '登   录',
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 20.0),
                    ),
                    color: Colors.white,
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}