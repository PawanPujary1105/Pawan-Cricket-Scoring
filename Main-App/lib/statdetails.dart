import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lct/playerstat.dart';
import 'package:firebase_database/firebase_database.dart';

class StatDet extends StatefulWidget {

  String teamName,seasonName;

  StatDet(this.teamName,this.seasonName);

  @override
  _StatDetState createState() => _StatDetState(teamName,seasonName);
}

class _StatDetState extends State<StatDet> {

  String teamName,seasonName;
  Map players={};
  List playerList=[];

  final dbRef=FirebaseDatabase.instance.reference();

  _StatDetState(this.teamName,this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/players').once().then((snapshot){
      players=snapshot.value;
      players.forEach((key, value) {
        if(value['team']==teamName){
          playerList.add(key);
        }
        setState(() {

        });
      });
    });
    super.initState();
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
                            Text(teamName+" Stats",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
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
                color: Colors.limeAccent[100],
              ),
              height: MediaQuery.of(context).size.height-151,
              child: ListView.builder(
                itemCount: playerList.length,
                itemBuilder: (context,i){
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayerStat(playerList[i],seasonName)));
                    },
                    child: Container(
                      height: 50,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(width: 3)
                        ),
                        color: Colors.redAccent[400],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(playerList[i],textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
