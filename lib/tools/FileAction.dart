import 'dart:convert';
import 'dart:io';

class FileAction {
  File _file;
  FileAction(String path) {
    this._file = new File(path);
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
