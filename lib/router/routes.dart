import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:nga/router/route_handlers.dart';

class Routes {
  static String root = "/";
  static String homePage = "/homePage";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("该页面未找到!!!");
    });
    router.define(root, handler: rootHandler);
    router.define(homePage, handler: homePageRouteHandler, transitionType: TransitionType.fadeIn);
  }
}
