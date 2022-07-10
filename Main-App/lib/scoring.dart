import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Scoring extends StatefulWidget {

  String matchId,seasonName;
  int matchNo;

  Scoring(this.matchId,this.matchNo,this.seasonName);

  @override
  _ScoringState createState() => _ScoringState(matchId,matchNo,seasonName);
}

class _ScoringState extends State<Scoring> {

  String matchId,seasonName;
  int matchNo;
  Map matchDet={};

  List expOpenBool=[false,false];
  Map batStats1={},batStats2={},bowlStats1={},bowlStats2={};
  List batPlayers1=[],bowlPlayers2=[],batPlayers2=[],bowlPlayers1=[],thisOver=[];
  List batStatsOrder1=[],batStatsOrder2=[],bowlStatsOrder1=[],bowlStatsOrder2=[];
  String batsman1="",batsman2="",bowler="",team1="",team2="",dTeam1="",dTeam2="",tossStatus="",matchStatus="";
  bool chooseTo=false,tossWon=false,resultDeclared=false,toss=false,strike=false,inn=false;
  int overs=24,bOneRuns=0,bOneBalls=0,bOne4=0,bOne6=0,bTwoRuns=0,bTwoBalls=0,bTwo4=0,bTwo6=0,bowlBalls=0,bowlRuns=0,bowlWics=0,wd1=0,nb1=0,b1=0,lb1=0,runs1=0,balls1=0,wics1=0,wd2=0,nb2=0,b2=0,lb2=0,runs2=0,balls2=0,wics2=0;
  final dbRef=FirebaseDatabase.instance.reference();

  Map outDet={'LBW':'LBW','BWD':'Bowled','CGT':'Caught','CBH':'Caught Behind','CAB':'Caught & Bowled','RUN':'Run Out','STD':'Stumped'};

  _ScoringState(this.matchId,this.matchNo,this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/fixtures/'+matchId).onValue.listen((event) {
      matchDet=event.snapshot.value;

      batsman1=matchDet['batsman1'];
      batsman2=matchDet['batsman2'];
      team1=matchDet['team1'];
      team2=matchDet['team2'];
      chooseTo=matchDet['chooseTo'];
      overs=matchDet['overs'];
      tossWon=matchDet['tossWon'];
      toss=matchDet['toss'];
      inn=matchDet['inn'];
      strike=matchDet['strike'];
      if(matchDet['thisOver']!=null){
        thisOver=matchDet['thisOver'];
      }
      if(tossWon){
        if(chooseTo){
          tossStatus=team1+" won the toss and chose to Bat";
          dTeam1=team1;
          dTeam2=team2;
        }
        else{
          tossStatus=team1+" won the toss and chose to Bowl";
          dTeam1=team2;
          dTeam2=team1;
        }
      }
      else{
        if(chooseTo){
          tossStatus=team2+" won the toss and chose to Bat";
          dTeam1=team2;
          dTeam2=team1;
        }
        else{
          tossStatus=team2+" won the toss and chose to Bowl";
          dTeam1=team1;
          dTeam2=team2;
        }
      }
      bowler=matchDet['bowler'];
      bOneRuns=matchDet['bOneRuns'];
      bOneBalls=matchDet['bOneBalls'];
      bOne4=matchDet['bOne4'];
      bOne6=matchDet['bOne6'];
      bTwoRuns=matchDet['bTwoRuns'];
      bTwoBalls=matchDet['bTwoBalls'];
      bTwo4=matchDet['bTwo4'];
      bTwo6=matchDet['bTwo6'];
      bowlBalls=matchDet['bowlBalls'];
      bowlRuns=matchDet['bowlRuns'];
      bowlWics=matchDet['bowlWics'];
      runs1=matchDet['runs1'];
      balls1=matchDet['balls1'];
      wics1=matchDet['wics1'];
      runs2=matchDet['runs2'];
      balls2=matchDet['balls2'];
      wics2=matchDet['wics2'];
      b1=matchDet['b1'];
      lb1=matchDet['lb1'];
      nb1=matchDet['nb1'];
      wd1=matchDet['wd1'];
      b2=matchDet['b2'];
      lb2=matchDet['lb2'];
      nb2=matchDet['nb2'];
      wd2=matchDet['wd2'];
      if(matchDet[dTeam1+'batStats']!=null){
        batStats1=matchDet[dTeam1+'batStats'];
      }
      if(matchDet[dTeam2+'bowlStats']!=null){
        bowlStats1=matchDet[dTeam2+'bowlStats'];
      }
      if(matchDet[dTeam2+'batStats']!=null){
        batStats2=matchDet[dTeam2+'batStats'];
      }
      if(matchDet[dTeam1+'bowlStats']!=null){
        bowlStats2=matchDet[dTeam1+'bowlStats'];
      }
      putInOrder();
      batPlayers1.clear();
      batPlayers2.clear();
      bowlPlayers1.clear();
      bowlPlayers2.clear();
      int i=-1;
      batStats1.keys.forEach((element) {
        i++;
        batPlayers1.add(batStats1.keys.elementAt(batStatsOrder1[i]));
      });
      i=-1;
      bowlStats1.keys.forEach((element) {
        i++;
        bowlPlayers2.add(bowlStats1.keys.elementAt(bowlStatsOrder1[i]));
      });
      i=-1;
      batStats2.keys.forEach((element) {
        i++;
        batPlayers2.add(batStats2.keys.elementAt(batStatsOrder2[i]));
      });
      i=-1;
      bowlStats2.keys.forEach((element) {
        i++;
        bowlPlayers1.add(bowlStats2.keys.elementAt(bowlStatsOrder2[i]));
      });
      matchStatusCal();
      setState(() {

      });
    });
    super.initState();
  }

  Widget batDet(bool inn,String batter){
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(inn?batStats1[batter]['order'].toString()+"."+batter:batStats2[batter]['order'].toString()+"."+batter,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              )),
              SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text(inn?batStats1[batter]['runs'].toString()+"("+batStats1[batter]['balls'].toString()+")":batStats2[batter]['runs'].toString()+"("+batStats2[batter]['balls'].toString()+")",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
              SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text(inn?batStats1[batter]['four'].toString():batStats2[batter]['four'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
              SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text(inn?batStats1[batter]['six'].toString():batStats2[batter]['six'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
              SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text(inn?(batStats1[batter]['sr']==null?"0.00":batStats1[batter]['sr'].toStringAsFixed(2)):(batStats2[batter]['sr']==null?"0.00":batStats2[batter]['sr'].toStringAsFixed(2)),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
            ],
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 2.0,bottom: 10),
            child: inn?Row(
              children: [
                batStats1[batter]['no']?Text("Not Out"):Text(outDet[batStats1[batter]['out']]),
                batStats1[batter]['no']?Container():batStats1[batter]['out']=='RUN'?Container():Text("  [ "+batStats1[batter]['bowler']+" ]"),
              ],
            ):Row(
              children: [
                batStats2[batter]['no']?Text("Not Out"):Text(outDet[batStats2[batter]['out']]),
                batStats2[batter]['no']?Container():batStats2[batter]['out']=='RUN'?Container():Text("  [ "+batStats2[batter]['bowler']+" ]"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bowlDet(bool inn,String bowler){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0,bottom: 2),
      child: Row(
        children: [
          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(inn?bowlStats1[bowler]['order'].toString()+"."+bowler:bowlStats2[bowler]['order'].toString()+"."+bowler,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          )),
          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text(inn?bowlStats1[bowler]['balls'].toString():bowlStats2[bowler]['balls'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text(inn?bowlStats1[bowler]['runs'].toString():bowlStats2[bowler]['runs'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text(inn?bowlStats1[bowler]['wics'].toString():bowlStats2[bowler]['wics'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.15,child: Text(inn?(bowlStats1[bowler]['eco']==null?"0.00":bowlStats1[bowler]['eco'].toStringAsFixed(2)):(bowlStats2[bowler]['eco']==null?"0.00":bowlStats2[bowler]['eco'].toStringAsFixed(2)),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
        ],
      ),
    );
  }

  matchStatusCal(){
    if(balls1==overs || wics1==10){
      if(runs2>runs1){
        matchStatus=dTeam2+" won by "+(10-wics2).toString()+" wickets";
        resultDeclared=true;
      }
      else if(balls2==overs ||  wics2==10){
        matchStatus=dTeam1+" won by "+(runs1-runs2).toString()+" runs";
        resultDeclared=true;
      }
      else{
        matchStatus=dTeam2+" need "+(runs1-runs2+1).toString()+" runs off "+(overs-balls2).toString()+" balls";
      }
    }
    else{
      matchStatus="no";
    }
  }

  putInOrder(){
    batStatsOrder1.clear();
    batStatsOrder2.clear();
    bowlStatsOrder1.clear();
    bowlStatsOrder2.clear();
    int order=1;
    for(int i=0;i<batStats1.keys.length;i++){
      int j=0;
      batStats1.keys.forEach((element) {
        if(batStats1[element]['order']==order){
          batStatsOrder1.add(j);
          order++;
        }
        j++;
      });
    }
    order=1;
    for(int i=0;i<batStats2.keys.length;i++){
      int j=0;
      batStats2.keys.forEach((element) {
        if(batStats2[element]['order']==order){
          batStatsOrder2.add(j);
          order++;
        }
        j++;
      });
    }
    order=1;
    for(int i=0;i<bowlStats1.keys.length;i++){
      int j=0;
      bowlStats1.keys.forEach((element) {
        if(bowlStats1[element]['order']==order){
          bowlStatsOrder1.add(j);
          order++;
        }
        j++;
      });
    }
    order=1;
    for(int i=0;i<bowlStats2.keys.length;i++){
      int j=0;
      bowlStats2.keys.forEach((element) {
        if(bowlStats2[element]['order']==order){
          bowlStatsOrder2.add(j);
          order++;
        }
        j++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[100],
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Match "+matchNo.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ],
            ),
            matchStatus!="no"?SizedBox(height: 10,):Container(),
            matchStatus!="no"?Text(matchStatus,style:TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,):Container(),
            SizedBox(height: 5,),
            Text(toss?tossStatus:"Match Starts soon...",textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(colors: [Colors.yellowAccent,Colors.redAccent],stops: [0.3,0.7]),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width-31)*0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(dTeam1,style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text(runs1.toString()+"/"+wics1.toString()+" ("+(balls1~/6).toString()+"."+(balls1%6).toString()+")",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      height: 60,
                      width: 5,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width-31)*0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(dTeam2,style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Text(runs2.toString()+"/"+wics2.toString()+" ("+(balls2~/6).toString()+"."+(balls2%6).toString()+")",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            resultDeclared?Container():Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.yellowAccent,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text("Batsman:"),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      height: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text("Name"),
                        )),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text("Score")),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text("4s")),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text("6s")),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text("SR")),
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      height: 0.8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0,bottom: 2),
                      child: Row(
                        children: [
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: strike?Row(children: [Text(batsman1,style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(height:25,child: Image.asset('assets/bat.png'))],):Text(batsman1,style: TextStyle(fontWeight: FontWeight.bold),),
                          )),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text(bOneRuns.toString()+"("+(bOneBalls).toString()+")",style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text(bOne4.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text(bOne6.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text(((bOneRuns/bOneBalls)*100).toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: [
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: strike?Text(batsman2,style: TextStyle(fontWeight: FontWeight.bold),):Row(children: [Text(batsman2,style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(height:25,child: Image.asset('assets/bat.png'))],),
                          )),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text(bTwoRuns.toString()+"("+(bTwoBalls).toString()+")",style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text(bTwo4.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text(bTwo6.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text(((bTwoRuns/bTwoBalls)*100).toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      height: 2,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text("Bowler:"),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      height: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.42,child: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text("Name"),
                        )),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.14,child: Text("Balls")),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.14,child: Text("Runs")),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.14,child: Text("Wics")),
                        SizedBox(width:(MediaQuery.of(context).size.width-24)*0.16,child: Text("Eco")),
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      height: 0.8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0,bottom: 2),
                      child: Row(
                        children: [
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.42,child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(bowler,style: TextStyle(fontWeight: FontWeight.bold),),
                          )),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.14,child: Text(bowlBalls.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.14,child: Text(bowlRuns.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.14,child: Text(bowlWics.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                          SizedBox(width:(MediaQuery.of(context).size.width-24)*0.16,child: Text(((bowlRuns/bowlBalls)*6).toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inn?Text("Extras : WD - "+wd2.toString()+" | NB - "+nb2.toString()+"  | LB - "+lb2.toString()+" | B - "+b2.toString()):Text("Extras : WD - "+wd1.toString()+" | NB - "+nb1.toString()+" | LB - "+lb1.toString()+" | B - "+b1.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            resultDeclared?Container():Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2),
                  color: Colors.yellowAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width-24,
                    height: 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: thisOver.length+1,
                      itemBuilder: (context,i){
                        return i==0?Text("     This Over:     "):Text(thisOver[i-1]+"  ");
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ExpansionPanelList(
                children: [
                  ExpansionPanel(
                    backgroundColor: Colors.yellowAccent,
                    headerBuilder: (context,isOpen){
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("1st Innings",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                          ],
                        ),
                      );
                    },
                    body: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: Colors.red,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text("Batsman:"),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                height: 1,
                              ),
                              Row(
                                children: [
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text("Name"),
                                  )),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text("Score")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text("4s")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text("6s")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text("SR")),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Container(
                                  color: Colors.black,
                                  height: 0.8,
                                ),
                              ),
                              Column(
                                children: batPlayers1.map((e){
                                  return batDet(true,e);
                                }).toList(),
                              ),
                              Container(
                                color: Colors.black,
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text("Bowler:"),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                height: 1,
                              ),
                              Row(
                                children: [
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text("Name"),
                                  )),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text("Balls")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text("Runs")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text("Wics")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.15,child: Text("Eco")),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                height: 0.8,
                              ),
                              Column(
                                children: bowlPlayers2.map((e){
                                  return bowlDet(true,e);
                                }).toList(),
                              ),
                              Container(
                                color: Colors.black,
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Extras : WD - "+wd1.toString()+" | NB - "+nb1.toString()+" | LB - "+lb1.toString()+" | B - "+b1.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    isExpanded: expOpenBool[0],
                  ),
                  ExpansionPanel(
                    backgroundColor: Colors.yellowAccent,
                    headerBuilder: (context,isOpen){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("2nd Innings",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                        ],
                      );
                    },
                    body: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: Colors.red,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text("Batsman:"),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                height: 1,
                              ),
                              Row(
                                children: [
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text("Name"),
                                  )),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text("Score")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text("4s")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.09,child: Text("6s")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.18,child: Text("SR")),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Container(
                                  color: Colors.black,
                                  height: 0.8,
                                ),
                              ),
                              Column(
                                children: batPlayers2.map((e){
                                  return batDet(false,e);
                                }).toList(),
                              ),
                              Container(
                                color: Colors.black,
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text("Bowler:"),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                height: 1,
                              ),
                              Row(
                                children: [
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.46,child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text("Name"),
                                  )),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text("Balls")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text("Runs")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.13,child: Text("Wics")),
                                  SizedBox(width:(MediaQuery.of(context).size.width-24)*0.15,child: Text("Eco")),
                                ],
                              ),
                              Container(
                                color: Colors.black,
                                height: 0.8,
                              ),
                              Column(
                                children: bowlPlayers1.map((e){
                                  return bowlDet(false,e);
                                }).toList(),
                              ),
                              Container(
                                color: Colors.black,
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Extras : WD - "+wd2.toString()+" | NB - "+nb2.toString()+"  | LB - "+lb2.toString()+" | B - "+b2.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    isExpanded: expOpenBool[1],
                  ),
                ],
                expansionCallback: (i,val){
                  setState(() {
                    expOpenBool[i]=!val;
                  });
                },
                animationDuration: Duration(milliseconds: 750),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

