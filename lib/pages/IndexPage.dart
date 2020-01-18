import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gentman/pages/HomePage.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _tabIndex = 0;
  List<Widget> tabItems = [
    HomePage(),
    
    Container(
      child: Text("setting"),
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _tabIndex = 0;
    });
  }

  void onBarTap(value) {
    print(value);
    setState(() {
      _tabIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: tabItems[_tabIndex],
            flex: 10,
          ),
          Expanded(
            child: CupertinoTabBar(
              onTap: onBarTap,
              currentIndex: _tabIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(
                    Icons.home,
                    color: Colors.redAccent,
                  ),
                  title: Text("首页"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  activeIcon: Icon(
                    Icons.bookmark_border,
                    color: Colors.redAccent,
                  ),
                  title: Text("收藏"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  activeIcon: Icon(
                    Icons.settings,
                    color: Colors.redAccent,
                  ),
                  title: Text("设置"),
                ),
              ],
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
