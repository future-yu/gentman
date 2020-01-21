import 'dart:convert';
import 'dart:io';

class FileAction {
  File _file;


  // 工厂模式
  factory FileAction(String path){
    return _getInstance(path);
  }
  static FileAction _instance;
  FileAction._internal(String path) {
    this._file = new File(path);
  }
  static FileAction _getInstance(String path) {
    if (_instance == null) {
      _instance = new FileAction._internal(path);
    }
    return _instance;
  }



  bool saveFile(content) {
    try {
      if(!this._file.existsSync()){
        this._file.createSync();
      }
      this._file.writeAsStringSync(content);
      return true;
      
    } catch (e) {
      return false;
    }
  }

  String readStringFile() {
    String content = jsonEncode({});
    try {
      if (this._file.existsSync()) {
        content = this._file.readAsStringSync();
      } else {
        this._file.createSync();
        this._file.writeAsStringSync("{}");
      }
      return content;
    } catch (e) {
      throw e;
    }
  }
}
