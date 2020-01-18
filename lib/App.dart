import 'package:flutter/material.dart';
import 'package:gentman/Loading.dart';
import 'package:gentman/providers/NormalStateProvider.dart';
import 'package:gentman/providers/SearchListProvider.dart';
import 'package:gentman/route/AppRouter.dart';
import 'package:provider/provider.dart';
import './route/Route.dart';
import './route/route_handler.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RouteConfigure route = RouteConfigure(routeMap);
    AppRouter.router = route.router;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>SearchListProvider(),),
        ChangeNotifierProvider(create: (_)=>NormalStateProvider(),),
      ],
      child: MaterialApp(
        title: "GentMan",
        home: LoadingPage(),
        onGenerateRoute: AppRouter.router.generator,
      ),
    );
  }
}
