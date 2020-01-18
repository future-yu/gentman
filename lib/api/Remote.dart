import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/middleware/BrowserDisguise.dart';

class Remote {
  Dio dio = Dio();
  Remote(String rootUrl, {CookieJar cookieJar}) {
    dio.options.baseUrl = rootUrl;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    dio.interceptors.add(BrowserDisguise());
//    dio.interceptors.add(CookieManager(cookieJar));
  }

  static String getCookieStr(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
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
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      CookieJar cookieJar = AppRemote.cookieJar;
      List<String> cookiesStr = response.headers[HttpHeaders.setCookieHeader];

      if (cookiesStr != null) {
        List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
        if (cookies != null) {
          cookieJar.saveFromResponse(
            Uri.parse(Config.ex_remote_url),
            cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
          );
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getHtml(String target) async {
    try {
      Response response = await dio.get(target);
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
