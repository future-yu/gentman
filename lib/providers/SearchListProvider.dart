import 'package:flutter/widgets.dart';
import 'package:gentman/models/ListItemModel.dart';

class SearchListProvider extends ChangeNotifier {
  List<ListItemModel> _list=[];
  get list=>_list;
  List<ListItemModel> initAllList(List<ListItemModel> items) {
    _list = items;
    notifyListeners();
    return _list;
  }

  void addSearchList(List<ListItemModel> items) {
    _list.addAll(items);
    notifyListeners();
  }
}
