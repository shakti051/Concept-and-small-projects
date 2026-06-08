import 'package:flutter/material.dart';
import 'package:task_app1/screens/recycle_bin.dart';
import 'package:task_app1/screens/pending_screen.dart';
import '../screens/tabs_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSittings){
    switch(routeSittings.name){
      case RecycleBin.id:
      return MaterialPageRoute(builder:(_)=> RecycleBin());
    case TabsScreen.id:
      return MaterialPageRoute(builder:(_)=> TabsScreen());
    default:
    return MaterialPageRoute(builder:(_)=> Text("No Route found"));
    }
  }
}
