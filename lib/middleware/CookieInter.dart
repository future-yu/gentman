import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gentman/tools/AppTools.dart';
import 'package:gentman/tools/UserStatusAction.dart';

class CookieInter extends Interceptor{
  String _cookies;
  CookieInter({String cookies,}){
    this._cookies =cookies;
  }
  @override
  Future onRequest(RequestOptions options) {
    
    options.headers[HttpHeaders.cookieHeader] = this._cookies;
    
    return super.onRequest(options);
  }   

  @override
  Future onResponse(Response response) {
    UserStatusAction userStatusAction = AppTools.userStatusAction;
    Cookie cookie = Cookie.fromSetCookieValue(response.headers["set-cookie"][0]);
    String expires_str = cookie.expires.toString();
    userStatusAction.setUserConfigure({
      "expires":expires_str,
    });
    return super.onResponse(response);
  }

}