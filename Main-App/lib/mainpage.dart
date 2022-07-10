import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lct/pointstable.dart';
import 'package:lct/scoring.dart';
import 'package:lct/stats.dart';
import 'package:lct/topbatsman.dart';
import 'package:lct/topbowler.dart';
import 'package:firebase_database/firebase_database.dart';


class MainPage extends StatefulWidget {

  String seasonName;
  MainPage(this.seasonName);

  @override
  _MainPageState createState() => _MainPageState(seasonName);
}

class _MainPageState extends State<MainPage> {

  Map fixt={},playOffName={};
  String seasonName;
  int playCount=-1;
  List<bool> playOff=[];
  List overs=[],team1=[],team2=[],dTeam1=[],dTeam2=[],runs1=[],balls1=[],wics1=[],runs2=[],balls2=[],wics2=[],tossWon=[],chooseTo=[],status=[],matchId=[],playOffList=[];
  final dbRef=FirebaseDatabase.instance.reference();

  _MainPageState(this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/fixtures').onValue.listen((event) {
      if(event.snapshot.value!=null){
        fixt=event.snapshot.value;
        team1.clear();
        team2.clear();
        dTeam1.clear();
        dTeam2.clear();
        runs1.clear();
        runs2.clear();
        balls1.clear();
        balls2.clear();
        wics1.clear();
        wics2.clear();
        status.clear();
        tossWon.clear();
        chooseTo.clear();
        matchId.clear();
        playOff.clear();
        playOffName.clear();
        fixt.keys.forEach((element) {
          matchId.add(element);
        });
        fixt.values.forEach((element) {
          dTeam1.add(element['team1']);
          dTeam2.add(element['team2']);
          status.add(element['status']);
          runs1.add(element['runs1']);
          balls1.add(element['balls1']);
          wics1.add(element['wics1']);
          runs2.add(element['runs2']);
          balls2.add(element['balls2']);
          wics2.add(element['wics2']);
          tossWon.add(element['tossWon']);
          chooseTo.add(element['chooseTo']);
          playOff.add(element['playoff']);
          overs.add(element['overs']);
          if(element['playoff']){
            playOffList.add(element['playOffName']);
          }
          if(element['tossWon']){
            if(element['chooseTo']){
              team1.add(element['team1']);
              team2.add(element['team2']);
            }
            else{
              team1.add(element['team2']);
              team2.add(element['team1']);
            }
          }
          else{
            if(element['chooseTo']){
              team1.add(element['team2']);
              team2.add(element['team1']);
            }
            else{
              team1.add(element['team1']);
              team2.add(element['team2']);
            }
          }
        });
        playCount=-1;
        for(int i=0;i<fixt.keys.length;i++){
          if(playOff[i]){
            playOffName[matchId[i]]=playOffList[++playCount];
          }
        }
        setState(() {

        });
      }
    });
    super.initState();
  }

  matchStatus(int n){
    String res="";
    if(balls1[n]==overs[n] ||  wics1[n]==10){
      if(runs2[n]>runs1[n]){
        res=team2[n]+" won by "+(10-wics2[n]).toString()+" wickets";
      }
      else if(balls2[n]==overs[n] || wics2[n]==10){
        res=team1[n]+" won by "+(runs1[n]-runs2[n]).toString()+" runs";
      }
      else{
        res=team2[n]+" need "+(runs1[n]-runs2[n]+1).toString()+" off "+(overs[n]-balls2[n]).toString()+" balls";
      }
    }
    else{
      res=(tossWon[n]?dTeam1[n]:dTeam2[n])+" chose to "+(chooseTo[n]?"Bat":"Bowl");
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[100],
        child: Column(
          children: [
            Container(
              height: 250,
              child: CarouselSlider(
                items: ['Points Table','Top Batsmen','Top Bowler','Statistics'].map((i){
                  Map imageView={'Points Table':Image.asset('assets/points.png'),'Top Batsmen':Image.asset('assets/batsman.png'),'Top Bowler':Image.asset('assets/bowler.png'),'Statistics':Image.asset('assets/statistics.png')};
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: (){
                            switch(i){
                              case 'Points Table':
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>PointsTable(seasonName)));
                                break;
                              case 'Top Batsmen':
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TopBatsman(seasonName)));
                                break;
                              case 'Top Bowler':
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TopBowler(seasonName)));
                                break;
                              case 'Statistics':
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Stats(seasonName)));
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width-100,
                              height: 240,
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom:0,
                                    right: 0,
                                    left: 0,
                                    top: 40,
                                    child: Container(
                                      height:100,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                          side: BorderSide(
                                            width: 2,
                                          ),
                                        ),
                                        elevation: 5,
                                        color: Colors.yellowAccent,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(40.0),
                                              child: Text('$i', style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.pink[600]),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: i=='Statistics'?20:0,
                                    bottom: i=='Statistics'?70:i=='Points Table'?50:30,
                                    right: i=='Top Batsmen'?-40:i=='Statistics'?20:0,
                                    child: Container(
                                      child: imageView[i],
                                    ),
                                  ),
                                ], 
                              ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3),
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                color: Colors.yellowAccent,
              ),
              height: MediaQuery.of(context).size.height-250,
              child: fixt.length==0?Center(child: Text('No matches scheduled..'),):ListView.builder(
                itemCount: team1.length,
                itemBuilder: (context,i){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 5),
                    child: Container(
                      height: 120,
                      child: GestureDetector(
                        onTap: (){
                          if(status[i]!='yet'){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Scoring(matchId[i],i+1,seasonName)));
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(55)),
                          ),
                          elevation: 5,
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(playOff[i]?playOffName[matchId[i]]:("Match "+(i+1).toString()),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(team1[i],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                  Text("  Vs  ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                  Text(team2[i],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ],
                              ),
                              SizedBox(height: 5,),
                              status[i]!='yet'?Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(runs1[i].toString()+"/"+wics1[i].toString()+" ("+(balls1[i]~/6).toString()+"."+(balls1[i]%6).toString()+")",style: TextStyle(color: Colors.white),),
                                  Text("          -          ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  balls1[i]==overs[i]?Text(runs2[i].toString()+"/"+wics2[i].toString()+" ("+(balls2[i]~/6).toString()+"."+(balls2[i]%6).toString()+")",style: TextStyle(color: Colors.white),):Text("Yet to bat",style: TextStyle(color: Colors.white),),
                                ],
                              ):Container(),
                              SizedBox(height: 5,),
                              Text(status[i]=='yet'?"Match Starts soon..":matchStatus(i),style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white),),
                            ],
                          ),
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
