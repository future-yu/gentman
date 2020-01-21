import 'dart:io';

import 'package:dio/dio.dart';

///添加浏览器特有的头部
class BrowserDisguise extends Interceptor{
 
  @override
  Future onRequest(RequestOptions options) {
    options.headers[HttpHeaders.acceptHeader]="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9";
    options.headers[HttpHeaders.acceptLanguageHeader]='zh-CN,zh;q=0.9';
//    options.headers[HttpHeaders.contentTypeHeader] = "text/html; charset=UTF-8";
    options.headers[HttpHeaders.userAgentHeader]='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36';
    return super.onRequest(options);
  }

}