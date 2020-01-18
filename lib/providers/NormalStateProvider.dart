import 'package:flutter/widgets.dart';
import 'package:gentman/Configs.dart';

class NormalStateProvider extends ChangeNotifier{
  int pageIndex=0;
  String site;
  String searchText="";
  int max_page=0;
  int current_page=0;

  bool _isloading=false;
  get isloading=>_isloading;
  set isloading(bool value){
    _isloading = value;
    notifyListeners();
  }
  void setSite(String siteIndex){
    site = Config.sites[siteIndex];
    notifyListeners();
  }


}