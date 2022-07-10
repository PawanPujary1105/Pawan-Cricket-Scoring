import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder{

  final Widget page;
  FadeRoute(this.page):
    super(
        pageBuilder: (BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,)=>page,
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,Widget child)=>FadeTransition(opacity: animation,child: child,),
    );
}

class SlideLeftRoute extends PageRouteBuilder{

  final Widget page;
  SlideLeftRoute(this.page):
        super(
        pageBuilder: (BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,)=>page,
        transitionDuration: Duration(milliseconds: 600),
        transitionsBuilder: (BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,Widget child)=>SlideTransition(position: Tween<Offset>(begin: const Offset(1,0),end: Offset.zero,).animate(animation),child: child,),
      );
}