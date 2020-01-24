import 'dart:convert';
import 'dart:io';

import 'package:gentman/tools/FileAction.dart';
import 'package:gentman/tools/MapAction.dart';
class UserStatusAction {
  FileAction _fileAction;
  Map<String, dynamic> _config;

  // 工厂模式
  factory UserStatusAction(){
    return _getInstance();
  }
  static UserStatusAction get instance => _getInstance();
  static UserStatusAction _instance;
  UserStatusAction._internal() {
    //
  }
  static UserStatusAction _getInstance() {
    if (_instance == null) {
      _instance = new UserStatusAction._internal();
    }
    return _instance;
  }

  //设置cookie
  void setCookies(String site,List<Cookie> cookies){
    List existCookie = getCookies(site);
    String host  = Uri.parse(site).host;
    if(existCookie.length>0){
      cookies.forEach((Cookie cookie){
        existCookie.removeWhere((eCookie){
            return eCookie.name == cookie.name;
        });
      });
    }
    existCookie.addAll(cookies);
    var cookieArr = [];
    existCookie.forEach((cookie){
      cookieArr.add(cookie.toString());
    });
    setUserConfigure({
      host:jsonEncode(cookieArr),
    });
  }

  //获取cookie
  List getCookies(String site){
    var cookies_str = _config[Uri.parse(site).host];
    Map<String,Cookie> cookiesMap={};
    List<Cookie> cookies = [];
    if(cookies_str!=null){
      List cookiesArr = jsonDecode(cookies_str);
      cookiesArr.forEach((cookieStr){
        cookies.add(Cookie.fromSetCookieValue(cookieStr));
      });
    }
    cookies.forEach((Cookie cookie){
      cookiesMap[cookie.name] = cookie;
    });

    return cookiesMap.values.toList();
  }

  //获取config
  get userConfigure=>this._config;

  //设置配置
  bool setUserConfigure(config){
    var tmp = MapAction.getUpdateMap(this._config, config);
    if(this._fileAction.saveFile(jsonEncode(tmp))){
      this._config = tmp;
      return true;
    }
    return false;
  }
  
  //初始化配置
  Future initConfig(Directory appDocDir) async {
    if (this._config == null) {
      String appDocPath = appDocDir.path;
      this._fileAction = new FileAction("$appDocPath/config.json");
      String configStr = this._fileAction.readStringFile();
      this._config = jsonDecode(configStr);
    }
  }

  /*
   * 判定登陆状态
   * 已登陆返回cookie，没登录返回用户名，密码
   */
  Map<String, String> getUserInfo() {
    return {
      "username": this._config['username']==null?"":this._config['username'],
      "password": this._config['password']==null?"":this._config['password'],
      "site":this._config["site"]==null?"":this._config['site'],
    };
  }

}
