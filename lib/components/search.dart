import 'package:flutter/material.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/providers/NormalStateProvider.dart';
import 'package:gentman/providers/SearchListProvider.dart';
import 'package:gentman/tools/EXParser.dart';
import 'package:provider/provider.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({Key key}) : super(key: key);

  @override
  _InputSearchState createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  NormalStateProvider _state;
  TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _state = Provider.of<NormalStateProvider>(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _onSearch() async {
    Remote remote = Remote();
    try {
      _state.isloading = true;
      String searchText = _searchController.text;
      searchText = searchText.trim().replaceAll(new RegExp(r"\s+"), r"+");
      String html = await remote.exSearch(queryString: searchText);
      var allData = EXParser.getSearchList(html);
      NormalStateProvider normalStateProvider =
          Provider.of<NormalStateProvider>(context, listen: false);
      Provider.of<SearchListProvider>(context, listen: false)
          .initAllList(allData.list);
      normalStateProvider.searchText = searchText;
      normalStateProvider.max_page = allData.max_length;
      normalStateProvider.current_page = 0;
      _state.isloading = false;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
      color: Colors.lightBlueAccent,
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: false,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: "请输入查询内容...",
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(220, 220, 220, 1.0)),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0)))),
                ),
              )),
          Expanded(
            child: FlatButton(
              color: Colors.blue,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Icon(Icons.search),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed:_onSearch,
            ),
          ),
        ],
      ),
    );
  }
}
