import 'package:flutter/material.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/components/NetImage.dart';
import 'package:gentman/models/ItemDetail.dart';
import 'package:gentman/route/AppRouter.dart';
import 'package:gentman/tools/EXParser.dart';

class DetailPage extends StatefulWidget {
  final String _target;
  DetailPage(this._target);

  @override
  _DetailPageState createState() => _DetailPageState(_target);
}

class _DetailPageState extends State<DetailPage> {
  final String _target;
  _DetailPageState(this._target);
  ItemDetail _itemDetail;

  void _loadDetail()async{
    Remote remote = Remote();
    String html = await remote.getHtml(_target,);
    ItemDetail itemDetail = EXParser.getItemDetail(html,_target);
    setState(() {
      _itemDetail = itemDetail;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDetail();

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
      body: Column(
        children: <Widget>[
          DetailPageInfo(_itemDetail),
        ],
      ),
    );
  }
}

class DetailPageInfo extends StatefulWidget{
  final ItemDetail _itemDetail;
  DetailPageInfo(this._itemDetail);

  @override
  _DetailPageInfoState createState() =>_DetailPageInfoState(_itemDetail);
}
class _DetailPageInfoState extends State<DetailPageInfo>{
  final ItemDetail _itemDetail;
  _DetailPageInfoState(this._itemDetail);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                NetImage(
                  _itemDetail.thumbUrl
                ),
              ],
            ),
          )
        ],
      ),

    );
  }


}