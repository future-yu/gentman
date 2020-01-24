import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gentman/pages/CollectionPage/CollectionPage.dart';
import 'package:gentman/pages/HomePage/HomePage.dart';
import 'package:gentman/pages/UserPage/UserPage.dart';

class IndexPage extends StatefulWidget {
  final int tabIndex;
  IndexPage(this.tabIndex);
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _tabIndex = 0;
  List<Widget> tabItems = [
    HomePage(),
    CollectionPage(),
    UserPage(),
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      _tabIndex = widget.tabIndex;
    });
  }

  void onBarTap(value) {
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
