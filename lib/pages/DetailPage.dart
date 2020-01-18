import 'package:flutter/material.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/route/AppRouter.dart';

class DetailPage extends StatefulWidget {
  final String _target;
  DetailPage(this._target);

  @override
  _DetailPageState createState() => _DetailPageState(_target);
}

class _DetailPageState extends State<DetailPage> {
  final String _target;
  _DetailPageState(this._target);

  void loadDetail()async{
    String html = await AppRemote.remote.getHtml(_target);
    print(_target);

  }

  @override
  void initState() {
    super.initState();
    loadDetail();

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
      body: Text("data"),
    );
  }
}
