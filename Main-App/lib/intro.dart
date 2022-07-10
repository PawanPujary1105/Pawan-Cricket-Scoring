import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lct/pageroute.dart';
import 'package:lct/selectseason.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 5), (){
      Navigator.pushReplacement(context, FadeRoute(SelectSeason()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white,Colors.indigoAccent],
            stops: [0.65,0.90],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Image.asset('assets/yplintro.png'),
            SizedBox(height: 110,),
            Text("The Official App",style: TextStyle(color: Colors.black,fontSize: 22,fontStyle: FontStyle.italic),),
            SizedBox(height: 5,),
            Text("of",style: TextStyle(color: Colors.black,fontSize: 22,fontStyle: FontStyle.italic),),
            SizedBox(height: 5,),
            Text("Yermal Premier League",style: TextStyle(color: Colors.black,fontSize: 28,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
