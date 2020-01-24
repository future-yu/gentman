// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/Remote.dart';

void main() {
  test("login test", () async {
    Remote remote = Remote();
    remote.addProxy("localhost:1087");
    var res = await remote.loadCookies(
      username: "rulersex",
      password: "daohaodequsi",
    );
    print("object");
  });
  test("search test", () async {
    Remote remote = Remote();
    remote.rootUrl = Config.ex_remote_url;
    remote.addProxy("localhost:8888");
    String html = await remote.exSearch(queryString: "niku+ringo+chinese");
    print(html);
//    EXParser parser = EXParser(html);
//    var data = parser.getSearchList();

    print("object");
  });

  test("cookiejar test", (){
    CookieJar cookieJar = CookieJar();
    cookieJar.saveFromResponse(Uri.parse(Config.ex_remote_url), Config.cookies);
    print(cookieJar.loadForRequest(Uri.parse(Config.ex_remote_url)));

  });

  test("http test", ()async{
//      http.post("")
  });
}
