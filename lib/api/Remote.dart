import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/middleware/BrowserDisguise.dart';
import 'package:gentman/middleware/CookieInter.dart';
import 'package:gentman/tools/UserStatusAction.dart';

class Manager {
  // 工厂模式
  factory Manager() =>_getInstance();
  static Manager get instance => _getInstance();
  static Manager _instance;
  Manager._internal() {
    // 初始化
  }
  static Manager _getInstance() {
    if (_instance == null) {
      _instance = new Manager._internal();
    }
    return _instance;
  }
}


class Remote {
  Dio dio = Dio();
  String _rootUrl;
  // 工厂模式
  factory Remote(){
    return _getInstance();
  }
  static Remote get instance => _getInstance();
  static Remote _instance;
  Remote._internal() {
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    addInterceptor(BrowserDisguise());
  }
  static Remote _getInstance() {
    if (_instance == null) {
      _instance = new Remote._internal();
    }
    return _instance;
  }

  //设置rooturl
  set rootUrl(value){
    _rootUrl = value;
    dio.options.baseUrl = _rootUrl;
  }

  //cookie转str
  static String getCookieStr(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }

  void addInterceptor(Interceptor interceptor){
    dio.interceptors.add(interceptor);
  }
  ///cookie转str
  static Map<String, String> cookiesToStr(List<String> cookies) {
    Map<String, String> cookieInfo = {};
    cookies.forEach((String cookieStr) {
      Cookie cookie = Cookie.fromSetCookieValue(cookieStr);
      cookieInfo[cookie.name] = cookie.toString();
    });
    return cookieInfo;
  }

  ///添加代理
  void addProxy(String proxy_url) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        return "PROXY $proxy_url";
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  String getQuery(Map<String, dynamic> query) {
    List<String> queryArr = [];
    query.forEach((key, value) {
      queryArr.add("$key=$value");
    });
    return queryArr.join("&&");
  }

  //ex查询
  Future<String> exSearch({String queryString = "", int pageIndex = 0}) async {
    try {
      String queryStr = getQuery({
        "f_search": queryString,
        "page": pageIndex,
      });
      String remote_url = "${Config.ex_remote_url}?$queryStr";
      Response response = await dio.get(
        remote_url,
        options: RequestOptions(
          headers: {
            HttpHeaders.cookieHeader:Remote.getCookieStr(Config.cookies),
          }
        ),
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  //登陆加载cookie
  Future<bool> loadCookies({String username, String password}) async {
    try {
      dio.options.contentType = Headers.formUrlEncodedContentType;
      Response response = await dio.post(
        Config.login_url,
        data: {
          "PassWord": password,
          "UserName": username,
          "CookieDate": 1,
          "b": "d",
          "bt": "1-2",
          "ipb_login_submit": "Login!",
          "temporary_https":"off",
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            HttpHeaders.refererHeader:"https://e-hentai.org/bounce_login.php?b=d&bt=1-1",
          }
        ),
      );

      //存储cookie
      if (response != null && response.headers != null) {
        List<String> cookiesStr = response.headers[HttpHeaders.setCookieHeader];
        List<Cookie> cookies = cookiesStr.map((str) => Cookie.fromSetCookieValue(str)).toList();
        UserStatusAction state = UserStatusAction();
        state.setCookies(
          Config.ex_remote_url,
          cookies,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getHtml(String target) async {
    try {
      Response response = await dio.get(target,options:RequestOptions(
        headers: {
          HttpHeaders.cookieHeader:getCookieStr(Config.cookies),
        }
      ),);
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
