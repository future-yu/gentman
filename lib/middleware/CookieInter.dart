import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/tools/UserStatusAction.dart';

class CookieInter extends Interceptor {
  final UserStatusAction state ;
  CookieInter(this.state);

  @override
  Future onRequest(RequestOptions options) {
    List cookies = state.getCookies(options.baseUrl);
    cookies.removeWhere((cookie) {
      if (cookie.expires != null) {
        return cookie.expires.isBefore(DateTime.now());
      }
      return false;
    });
    String cookie = getCookies(cookies);
    print(getCookies(Config.cookies));
    print(cookie);
    if (cookie.isNotEmpty) {
      options.headers[HttpHeaders.cookieHeader] = cookie;
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    if (response != null && response.headers != null) {
      List<String> cookiesStr = response.headers[HttpHeaders.setCookieHeader];
      if(cookiesStr!=null){
        List<Cookie> cookies =
        cookiesStr.map((str) => Cookie.fromSetCookieValue(str)).toList();
        UserStatusAction state = UserStatusAction();
        state.setCookies(
          response.request.uri.toString(),
          Config.cookies,
        );
      }
    }
    return super.onResponse(response);
  }

  static String getCookies(List<Cookie> cookies) {
    cookies.removeWhere((cookie){
      if(cookie.name=='ipb_member_id'||cookie.name=="ipb_pass_hash"){
        return false;
      }
      if(cookie.name=="igneous"&&cookie.value!="mystery"){
        return false;
      }
      return true;
    });
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }
}
