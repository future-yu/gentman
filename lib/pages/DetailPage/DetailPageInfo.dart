//上半部分
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/components/NetImage.dart';
import 'package:gentman/models/ItemDetail.dart';
import 'package:gentman/providers/NormalStateProvider.dart';
import 'package:gentman/route/AppRouter.dart';
import 'package:provider/provider.dart';

class DetailPageInfo extends StatelessWidget {
  final ItemDetail _itemDetail;
  final String _cookieStr;
  DetailPageInfo(this._itemDetail, this._cookieStr);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: NetImage(
                  _itemDetail.thumbUrl,
                  width: 100,
                  headers: {
                    HttpHeaders.cookieHeader: _cookieStr,
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: DetailIntro(_itemDetail),
              ),
            ],
          ),
        ),
        DetailTags(_itemDetail.tags),
      ],
    );
  }
}

class DetailIntro extends StatelessWidget {
  final ItemDetail _itemDetail;
  DetailIntro(this._itemDetail);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(_itemDetail.ENTitle),
          ),
          Center(
            child: Text(_itemDetail.JapanTitle),
          ),
        ],
      ),
    );
  }
}

class DetailTags extends StatefulWidget {
  final Map<String, Map<String, String>> _tags;
  DetailTags(this._tags);

  @override
  _DetailTagsState createState() => _DetailTagsState();
}

class _DetailTagsState extends State<DetailTags> {
  Map<String, bool> hasClick = {};
  List<Widget> _tagWidgets;

  List<Widget> getTagWidget() {
    List<Widget> tags = [];
    widget._tags.forEach((String tagCata, Map<String, String> tagDetail) {
      tagDetail.forEach((String tagName, String tagTarget) {
        tags.add(
          Container(
            margin: EdgeInsets.only(top: 5, right: 5),
            child: FlatButton(
              color: hasClick[tagName] ? Colors.blue[100] : Colors.black54,
              highlightColor: Colors.yellowAccent,
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text(tagName),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                setState(() {
                  hasClick[tagName] = !hasClick[tagName];
                });
              },
            ),
          ),
        );
      });
    });
    return tags;
  }

  @override
  void initState() {
    super.initState();
    widget._tags.forEach((String tagCata, Map<String, String> tagDetail) {
      tagDetail.forEach((String tagName, String tagTarget) {
        hasClick[tagName] = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _tagWidgets = getTagWidget();
    });
    return Column(
      children: <Widget>[
        Wrap(
          children: _tagWidgets,
        ),
        Center(
          child: Consumer<NormalStateProvider>(
            builder: (BuildContext context, NormalStateProvider state,
                Widget widget) {
              return FlatButton(
                color: Colors.red,
                highlightColor: Colors.red[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text("搜索"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () {
                  List<String> tagSearch = [];
                  hasClick.forEach((String key, bool value) {
                    if (value) {
                      tagSearch
                          .add(key.trim().replaceAll(new RegExp(r"\s+"), r"+"));
                    }
                  });
                  state.searchText = tagSearch.join("+");
                  AppRouter.router.navigateTo(context, "/home");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
