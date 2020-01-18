// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentman/Configs.dart';
import 'package:gentman/api/Remote.dart';

import 'package:gentman/main.dart';

void main() {
  test("remote test", () async {
    Remote remote = Remote(Config.ex_remote_url);
    remote.addProxy("localhost:1087");
    var res = await remote.loadCookies(
      username: "rulersex",
      password: "daohaodequsi",
    );
    print("object");
  });
}
