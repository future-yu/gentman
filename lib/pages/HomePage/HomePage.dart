import 'package:flutter/material.dart';
import 'package:gentman/pages/HomePage/InputSearch.dart';
import 'package:gentman/pages/HomePage/SearchList.dart';

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState()=>_HomePageState();
}
class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Column(
        children: <Widget>[
          InputSearch(),
          Expanded(
            child: SearchList(),
          )
        ],
      ),
    );
  }
}