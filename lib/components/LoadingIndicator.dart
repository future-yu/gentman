import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget{

  @override
  _LoadingIndicatorState createState() =>_LoadingIndicatorState();
}
class _LoadingIndicatorState extends State<LoadingIndicator>{

  double _process;
  @override
  void initState() {
    super.initState();
    _process = 0.0;
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 8,
            width: 100,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}