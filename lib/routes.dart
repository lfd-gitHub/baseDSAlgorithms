import 'package:flutter/material.dart';
import 'package:jdsaa/views/anims/anim_hanoi.dart';
import 'package:jdsaa/views/anims/anim_index.dart';
import 'package:jdsaa/views/home.dart';

typedef RouteBuilder = Widget Function(BuildContext context, [dynamic args]);

class Routes {
  static const String home = "/home";
  static const String animsIndex = "/anims/index";
  static const String animsHanoi = "/anims/hanoi";

  static final routes = <String, RouteBuilder>{
    home: (_, [args]) => const HomePage(),
    animsIndex: (ctx, [args]) => const AnimIndexPage(),
    animsHanoi: (ctx, [args]) => const AnimHanoiPage(),
  };

  static Route onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final RouteBuilder? builder = routes[name];
    if (builder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(builder: (ctx) => builder(ctx, settings.arguments));
        return route;
      } else {
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      }
    }
    return MaterialPageRoute(builder: (ctx) => const HomePage());
  }
}
