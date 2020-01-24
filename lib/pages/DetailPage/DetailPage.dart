import 'package:flutter/material.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/models/ItemDetail.dart';
import 'package:gentman/pages/DetailPage/DetailPageInfo.dart';
import 'package:gentman/tools/EXParser.dart';
import 'package:gentman/tools/UserStatusAction.dart';

import 'package:gentman/Configs.dart';

class DetailPage extends StatefulWidget {
  final String _target;
  DetailPage(this._target);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _target;
  _DetailPageState();
  ItemDetail _itemDetail;
  String _cookieStr;

  Future _loadDetail() async {
    Remote remote = Remote();
    String html = await remote.getHtml(
      _target,
    );
    ItemDetail itemDetail = EXParser.getItemDetail(html, _target);

    return itemDetail;
  }

  @override
  void initState() {
    super.initState();
    _target = widget._target;
    UserStatusAction state = UserStatusAction();
    setState(() {
      _cookieStr = Remote.getCookieStr(state.getCookies(Config.ex_remote_url));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "详情",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _loadDetail(),
          builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                // 请求成功，显示数据
                return Column(
                  children: <Widget>[
                    DetailPageInfo(snapshot.data, _cookieStr),
                    Container(
                      color: Colors.greenAccent,
                      // child: ListView(),
                    ),
                  ],
                );
              }
            } else {
              return Container(
                color: Colors.grey,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                    strokeWidth: 8,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
