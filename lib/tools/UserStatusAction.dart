import 'dart:convert';
import 'dart:io';

import 'package:gentman/tools/AppTools.dart';
import 'package:gentman/tools/FileAction.dart';
import 'package:gentman/tools/MapAction.dart';
class UserStatusAction {
  FileAction _fileAction;
  Map<String, dynamic> _config;

  get userConfigure=>this._config;
  bool setUserConfigure(config){
    if(this._fileAction.saveFile(jsonEncode(MapAction.getUpdateMap(this._config, config)))){
      this._config = config;
      return true;
    }
    return false;
  }
  
  ///读取配置
 
  Future initConfig(Directory appDocDir) async {
    if (this._config == null) {
      String appDocPath = appDocDir.path;
      this._fileAction = new FileAction("$appDocPath/config.json");
      AppTools.fileAction = this._fileAction;
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
