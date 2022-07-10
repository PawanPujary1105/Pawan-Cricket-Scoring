import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerStat extends StatefulWidget {

  String playerName,seasonName;

  PlayerStat(this.playerName,this.seasonName);

  @override
  _PlayerStatState createState() => _PlayerStatState(playerName,seasonName);
}

class _PlayerStatState extends State<PlayerStat> {

  String playerName,seasonName;
  Map playerStat={};
  int inn=0,runs=0,balls=0,no=0,bestRuns=0,bestBalls=0,wics=0,bowlBalls=0,bowlRuns=0,bestbowlRuns=0,bestBowlWics=0;
  double eco=0.00,sR=0.00,avg=0.00;
  final dbRef=FirebaseDatabase.instance.reference();

  _PlayerStatState(this.playerName,this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/players/'+playerName).once().then((snapshot){
      playerStat=snapshot.value;
      inn=playerStat['innings'];
      runs=playerStat['runs'];
      balls=playerStat['balls'];
      bestRuns=playerStat['bestRuns'];
      bestBalls=playerStat['bestBalls'];
      wics=playerStat['wics'];
      bowlRuns=playerStat['bowlRuns'];
      bowlBalls=playerStat['bowlBalls'];
      no=playerStat['no'];
      bestbowlRuns=playerStat['bestBowlRuns'];
      bestBowlWics=playerStat['bestBowlWics'];
      eco=playerStat['eco'].toDouble();
      sR=playerStat['sr'].toDouble();
      avg=playerStat['avg'].toDouble();
      setState(() {

      });
    });
    super.initState();
  }

  statView(String det){
    return Column(
      children: [
        SizedBox(height: 50,width:MediaQuery.of(context).size.width/2-5,child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(det,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
          ],
        ),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.black,
              height: 1,
              width: MediaQuery.of(context).size.width/2-15,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 3)),
                color: Colors.teal[100],
              ),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width-60,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(playerName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1,),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 3,
                  ),
                ),
                color: Colors.limeAccent[400],
              ),
              height: MediaQuery.of(context).size.height-151,
              child: Row(
                children: [
                  Column(
                    children: [
                      statView("Innings"),
                      statView("Runs"),
                      statView("High Score"),
                      statView("Not Out"),
                      statView("Average"),
                      statView("Strike Rate"),
                      statView("Wickets"),
                      statView("Best"),
                      statView("Economy"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        height: MediaQuery.of(context).size.height-161,
                        width: 5,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      statView(inn.toString()),
                      statView(runs.toString()),
                      statView(bestRuns.toString()+"("+bestBalls.toString()+")"),
                      statView(no.toString()),
                      statView(avg.toStringAsFixed(2)),
                      statView(sR.toStringAsFixed(2)),
                      statView(wics.toString()),
                      statView(bestbowlRuns==-1?"DNB":bestBowlWics.toString()+" - ["+bestbowlRuns.toString()+" runs]"),
                      statView(eco.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
