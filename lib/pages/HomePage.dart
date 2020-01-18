import 'package:flutter/material.dart';
import 'package:gentman/components/search.dart';
import 'package:gentman/components/search_list.dart';

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