import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/route/AppRouter.dart';
import 'package:gentman/tools/AppTools.dart';
import 'package:gentman/tools/UserStatusAction.dart';
import 'package:path_provider/path_provider.dart';

//启动APP加载页面
class LoadingPage extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<LoadingPage> {
  Future jumpPage() async {
    UserStatusAction userStatusAction = UserStatusAction();
    Directory appDocdir = await getApplicationDocumentsDirectory();
    //初始化cookie存储
    PersistCookieJar cookieJar =
        PersistCookieJar(dir: "${appDocdir.path}/.cookies/");
    //初始化用户配置管理
    userStatusAction.initConfig(appDocdir);
    Map<String, String> userInfo = userStatusAction.getUserInfo();
    AppRemote.cookieJar = cookieJar;


    if (userInfo["site"].isNotEmpty) {
      //初始化http请求
      AppRemote.remote =
          Remote(Config.sites[userInfo["site"]], cookieJar: cookieJar);
    }
    AppTools.userStatusAction = userStatusAction;

    //判断默认的网站选择
    switch (userInfo["site"]) {
      case "0": //exhentai
        List cookieList =
            cookieJar.loadForRequest(Uri.parse(Config.sites[userInfo["site"]]));
        int hasCookie = 0;
        //判断登陆状态
        cookieList.forEach((cookie) {
          if (cookie.name == "ipb_member_id" ||
              cookie.name == "ipb_pass_hash") {
            hasCookie++;
          }
        });
        //没有登陆直接跳转login页面
        if (hasCookie < 2) {
          AppRouter.router.navigateTo(
            context,
            "/login?uname=${userInfo['username']}&&pwd=${userInfo['password']}",
          );
        } else {
          AppRouter.router.navigateTo(context, "/");
        }
        break;
      case "1":
      case "2":
      case "3":
        AppRouter.router.navigateTo(context, "/");
        break;
      default:
        AppRouter.router.navigateTo(
          context,
          "/login?uname=${userInfo['username']}&&pwd=${userInfo['password']}",
        );
    }

    // cookieJar.saveFromResponse(Uri.parse(Config.ex_remote_url), Config.cookies);
    // List cookieList = cookieJar.loadForRequest(Uri.parse(Config.ex_remote_url));
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), this.jumpPage);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Stack(
          children: <Widget>[
            //加载页面背景图
            Image.asset(
              'assets/images/loading.jpeg',
            ),
            //加载页面文字内容
            Positioned(
              //距离顶部100
              top: 100,
              child: Container(
                width: 400,
                child: Center(
                  child: Text(
                    'Flutter企业站',
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 36.0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
