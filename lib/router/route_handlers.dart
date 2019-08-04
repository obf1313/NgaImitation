import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:nga/pages/user/loginPage.dart';
import 'package:nga/pages/home/homePage.dart';

var rootHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var homePageRouteHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomePage();
});
