import 'package:flutter/material.dart';
import 'package:z_admin/view/screen/entry/login.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
   Future.delayed(Duration(seconds:3),
   (){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
   }
   );
    return Scaffold(
      body:Center(child: Image.asset('assets/images/logo.png'),)
    );
  }
}

