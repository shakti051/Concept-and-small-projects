import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app_firebase/screens/login_screen.dart';
import 'package:task_app_firebase/screens/tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    openNext(context);
    super.initState();
  }

  void openNext(BuildContext context){
  Timer(Duration(milliseconds: 2000), (){
    if(_getStorage.read("token")==null || _getStorage.read("token")=="")
    Navigator.pushReplacementNamed(context, LoginScreen.id);
    else 
    Navigator.pushReplacementNamed(context, TabsScreen.id);
  } );    
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}