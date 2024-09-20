import 'package:flutter/material.dart';
import 'package:flutter_crud/pages/authFile/auth.dart';
import 'package:flutter_crud/pages/authFile/login_register.dart';
import 'package:flutter_crud/pages/HomePage/home_page.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({ Key ? key}) :super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
  
}

class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, 
      builder: (context , snapshot){
        if(snapshot.hasData){
          return Homepage();
        }else{
          return  const LoginPage();
        }
      }
      );
  }
  
}