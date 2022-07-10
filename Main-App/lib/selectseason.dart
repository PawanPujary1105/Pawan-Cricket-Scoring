import 'package:flutter/material.dart';

import 'mainpage.dart';
import 'pageroute.dart';

class SelectSeason extends StatelessWidget {
  const SelectSeason({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 80,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("YPL 2021",style: TextStyle(fontSize: 20,color: Colors.yellowAccent),),
                        SizedBox(width: 20,),
                        Icon(Icons.arrow_forward_rounded,color: Colors.yellowAccent,),
                      ],
                    ),
                    onPressed: (){
                      Navigator.push(context, SlideLeftRoute(MainPage("ypl2021")));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            SizedBox(
              width: 200,
              height: 80,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("YPL 2022",style: TextStyle(fontSize: 20,color: Colors.yellowAccent),),
                    SizedBox(width: 20,),
                    Icon(Icons.arrow_forward_rounded,color: Colors.yellowAccent,),
                  ],
                ),
                onPressed: (){
                  Navigator.push(context, SlideLeftRoute(MainPage("ypl2022")));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}