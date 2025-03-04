import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3),
    (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> login), predicate)
      
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
