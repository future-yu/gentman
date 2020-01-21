import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/models/ListItemModel.dart';
import 'package:gentman/providers/NormalStateProvider.dart';
import 'package:gentman/providers/SearchListProvider.dart';
import 'package:gentman/tools/EXParser.dart';
import 'package:gentman/tools/UserStatusAction.dart';
import 'package:provider/provider.dart';
import 'package:gentman/components/NetImage.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  static const loadingTag = "##loading##"; //表尾标记
  int _currentPage = 0;
  int _maxPage;
  String _cookieStr;
  int _cItemIndex = 0;
  bool _isloading = false;
  NormalStateProvider _state;

  ScrollController _controller = new ScrollController();

  List<ListItemModel> _items = [];

  void _loadList(int page) async {
    NormalStateProvider state =
        Provider.of<NormalStateProvider>(context, listen: false);
    _isloading = true;
    String searchText = state.searchText;
    Remote remote = Remote();
    String html = await remote.exSearch(
      pageIndex: page,
      queryString: searchText,
    );
    var allData = EXParser.getSearchList(html);
    state.current_page = page;
    state.max_page = allData.max_length;
    Provider.of<SearchListProvider>(context, listen: false)
        .addSearchList(allData.list);
    setState(() {
      _maxPage = allData.max_length;
      _currentPage = page;
    });
    _isloading = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state = Provider.of<NormalStateProvider>(context);
    List<Cookie> cookies = UserStatusAction().getCookies(_state.site);
    _cookieStr = Remote.getCookieStr(cookies);
  }

  @override
  void initState() {
    super.initState();
    _loadList(_currentPage);
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent - _controller.position.pixels <
          10.0) {
        if (_currentPage < _maxPage) {
          if (!_isloading) {
            _loadList(++_currentPage);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<SearchListProvider>(
      builder: (
        BuildContext context,
        SearchListProvider searchListProvider,
        Widget widget,
      ) {
        List<ListItemModel> list = searchListProvider.list;
        List<SearchItem> items = [];

        list.getRange(_cItemIndex, list.length).forEach((item) {
          items.add(SearchItem(item, screenWidth, _cookieStr));
        });

        return Scaffold(
          body: Container(
            child: ListView(
              controller: _controller,
              padding: EdgeInsets.only(left: 10, right: 10),
              children: <Widget>[
                Wrap(
                  spacing: 10.0, // 主轴(水平)方向间距
                  alignment: WrapAlignment.start,
                  children: items,
                ),
                Consumer<NormalStateProvider>(
                  builder: (context, state, child) {
                    bool isloading;
                    if (state.isloading == true) {
                      isloading = true;
                      _isloading = false;
                    }else{
                      isloading=_isloading;
                    }
                    return Visibility(
                      visible: isloading,
                      child: Container(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchItem extends StatelessWidget {
  final ListItemModel _item;
  final double screenWidth;
  final String cookieStr;
  SearchItem(this._item, this.screenWidth, this.cookieStr);

  @override
  Widget build(BuildContext context) {
    return Consumer<NormalStateProvider>(
      builder: (BuildContext context, state, Widget child) {
        return Container(
          width: (screenWidth - 50) / 4,
          padding: EdgeInsets.only(bottom: 10),
          height: 200,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: NetImage(
                        _item.cover_image_url,
                        detail_target: _item.detail_url,
                        width: (screenWidth - 50) / 4,
                        headers: {
                          HttpHeaders.cookieHeader: cookieStr,
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _item.title,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
