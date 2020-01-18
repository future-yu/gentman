import 'package:fluro/fluro.dart';

class RouteConfigure {
  RouteConfigure(Map<String,Handler> routeMap){
    this._routeMap = routeMap;
    this._router= Router();
    this._routeMap.forEach((String path,Handler handler){
        this._router.define(path, handler: handler);
    });
  }
  Map<String,Handler> _routeMap;
  Router _router;
  void addRoute(String path ,Handler handler) {
    this._router.define(path,handler:handler);
  }
  get router => _router;
  
}
