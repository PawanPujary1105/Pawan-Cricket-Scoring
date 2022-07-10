import 'package:flutter/material.dart';
import 'package:lct/statdetails.dart';
import 'package:firebase_database/firebase_database.dart';

class Stats extends StatefulWidget {

  String seasonName;

  Stats(this.seasonName);

  @override
  _StatsState createState() => _StatsState(seasonName);
}

class _StatsState extends State<Stats> {

  Map stat={};
  List teams=[];
  String seasonName;

  final dbRef=FirebaseDatabase.instance.reference();

  _StatsState(this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/teams').onValue.listen((event) {
      stat=event.snapshot.value;
      teams.clear();
      stat.keys.forEach((element) {
        teams.add(element);
      });
      setState(() {

      });
    });
    super.initState();
  }

  cardView(String teamName){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width-20,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StatDet(teamName,seasonName)));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(width: 3)
                ),
                color: Colors.redAccent[400],
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(teamName,textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("     Statistics",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 40,
                  bottom: 20,
                  child: Image.asset('assets/statistics.png'),
                ),
              ],
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
                itemCount: teams.length,
                itemBuilder: (context,i){
                  return cardView(teams[i]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
