import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gentman/pages/DetailPage.dart';
import 'package:gentman/pages/IndexPage.dart';
import 'package:gentman/pages/LoginPage.dart';

Handler loginHandler = Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return LoginPage(params['uname'][0],params["pwd"][0]);
    }
);

Handler rootHandler  = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return IndexPage();
  }
);

Handler detailHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return DetailPage(params["target"][0]);
  }
);




Map<String,Handler> routeMap={
  "/login":loginHandler,
  "/image/detail":detailHandler,
  "/":rootHandler,
};