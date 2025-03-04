import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 0),
    (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> widget.child!), (route)=>false);
      
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar'),
      ),
      body: Center(
        child: Text('welcome to firebase',style: TextStyle(color: Colors.blue,fontWeight:  FontWeight.bold),),
      ), 
    );
  }
}
