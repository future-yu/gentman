import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:gentman/api/Remote.dart';

class AppRemote{
  static Remote remote;
  static PersistCookieJar cookieJar;
  static CancelToken token = CancelToken();
}