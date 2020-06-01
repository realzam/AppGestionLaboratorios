import 'package:flutter/cupertino.dart';

class BouncingPageRoute extends PageRouteBuilder {
  final Widget widget;
  BouncingPageRoute({this.widget})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> setAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return FadeTransition(opacity: animation, child: child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> setAnimation) {
              return widget;
            });
}
