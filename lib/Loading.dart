import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/middleware/CookieInter.dart';
import 'package:gentman/providers/NormalStateProvider.dart';
import 'package:gentman/route/AppRouter.dart';
import 'package:gentman/tools/UserStatusAction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//启动APP加载页面
class LoadingPage extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<LoadingPage> {
  Future jumpPage() async {
    UserStatusAction state = UserStatusAction();
    Directory appDocdir = await getApplicationDocumentsDirectory();

    //初始化用户配置管理
    state.initConfig(appDocdir);
    Map<String, String> userInfo = state.getUserInfo();
    if (userInfo["site"].isNotEmpty) {
      //初始化http请求
      Remote remote = Remote();
      remote.rootUrl = Config.sites[userInfo["site"]];
      remote.addProxy("localhost:1087");
      remote.addInterceptor(CookieInter(state));
      Provider.of<NormalStateProvider>(context,listen: false).site = Config.sites[userInfo["site"]];

    }

    //判断默认的网站选择
    switch (userInfo["site"]) {
      case "0": //exhentai
        List cookieList = state.getCookies(Config.sites[userInfo["site"]]);
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
          AppRouter.router.navigateTo(context, "/home");
        }
        break;
      case "1":
      case "2":
      case "3":
        AppRouter.router.navigateTo(context, "/home");
        break;
      default:
        AppRouter.router.navigateTo(
          context,
          "/login?uname=${userInfo['username']}&&pwd=${userInfo['password']}",
        );
    }

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
