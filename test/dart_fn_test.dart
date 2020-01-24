
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gentman/Configs.dart';

class FileActionOne{
  // 工厂模式
  factory FileActionOne(String path){
    return _getInstance(path);
  }
  static FileActionOne _instance;
  FileActionOne._internal(String path) {
    //
//    this._file = new File(path);
    print(path);
  }
  static FileActionOne _getInstance(String path) {
    if (_instance == null) {
      _instance = new FileActionOne._internal(path);
    }
    return _instance;
  }
}
void main(){

  test("dart fn test", (){
    FileActionOne("xxx");
  });
  test("json test", (){
    Config.cookies.forEach((Cookie cookie){
      cookie.toString();
    });

  });

  test("regxp test", (){
      var reg = RegExp(r"\http.+\.jpg");
      var match = reg.firstMatch("width:250px; height:353px; background:transparent url(https://exhentai.org/t/bc/aa/bcaa34a18a2a8dd084b21f21aa2393d25cd5fb95-1407250-1280-1807-jpg_250.jpg) 0 0 no-repeat");
      print(match.group(0));
  });
}