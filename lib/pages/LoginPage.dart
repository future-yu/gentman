import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/AppRemote.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/providers/NormalStateProvider.dart';
import 'package:gentman/route/AppRouter.dart';
import 'package:gentman/tools/AppTools.dart';
import 'package:gentman/tools/UserStatusAction.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final String _username;
  final String _password;

  LoginPage(this._username, this._password);

  @override
  _LoginPageState createState() => _LoginPageState(
        this._username,
        this._password,
      );
}

class _LoginPageState extends State<LoginPage> {
  String _username;
  String _password;
  bool _hasClick = false;
  String _select = "0";
  bool _showInput = true;
  TextEditingController _usernameController;
  TextEditingController _pwdController;

  _LoginPageState(this._username, this._password);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _select = "0";
      _showInput = true;
      _hasClick = false;
      _usernameController = TextEditingController();
      _pwdController = TextEditingController();
      _usernameController.text = "rulersex"; //this._username;
      _pwdController.text = "daohaodequsi"; //this._password;
    });
  }

  @override
  Widget build(BuildContext context) {
    void login() async {
      var provider = Provider.of<NormalStateProvider>(context, listen: false);
      UserStatusAction state = UserStatusAction();
      //存储选中到site
      provider.setSite(_select);

      //不是exhentai直接跳页面，不用获取cookie
      if (!_showInput) {
        state.setUserConfigure({
          "site": Config.sites[_select],
        });
        AppRouter.router.navigateTo(context, '/');
        return;
      }

      Remote remote = Remote();
      remote.rootUrl = Config.sites[_select];

      //获取cookie
      if (_hasClick == false) {
        setState(() {
          this._hasClick = true;
        });
        bool cookieInit = await remote.loadCookies(
          username: _usernameController.text,
          password: _pwdController.text,
        );
        if (cookieInit) {
          state.setUserConfigure({
            "site": _select,
            "username":_usernameController.text,
            "password":_pwdController.text,
          });
          remote.rootUrl = Config.sites[_select];
          AppRouter.router.navigateTo(context, '/');
        } else {
          Fluttertoast.showToast(
            msg: "用户名或密码错误!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        setState(() {
          _hasClick = false;
        });
      }
    }

    void onDropDownChange(value) {
      setState(() {
        _select = value;
        _showInput = value == "0" ? true : false;
      });
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: 400,
              width: 600,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    width: 600,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("网站:"),
                        ),
                        Expanded(
                          flex: 10,
                          child: DropdownButton(
                            isExpanded: true,
                            value: _select,
                            items: [
                              DropdownMenuItem(
                                child: Text(Config.sites["0"]),
                                value: "0",
                              ),
                              DropdownMenuItem(
                                child: Text(Config.sites["1"]),
                                value: "1",
                              ),
                              DropdownMenuItem(
                                child: Text(Config.sites["2"]),
                                value: "2",
                              ),
                              DropdownMenuItem(
                                child: Text(Config.sites["3"]),
                                value: "3",
                              ),
                            ],
                            // itemHeight:20,
                            onChanged: onDropDownChange,
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _showInput,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "用户名",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _showInput,
                    child: TextField(
                      controller: _pwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "密码",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 200,
                    height: 50,
                    child: FlatButton(
                      child:
                          _hasClick ? CupertinoActivityIndicator() : Text("登陆"),
                      onPressed: login,
                      color: Colors.lightBlueAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
