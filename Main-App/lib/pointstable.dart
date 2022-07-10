import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PointsTable extends StatefulWidget {

  String seasonName;

  PointsTable(this.seasonName);

  @override
  _PointsTableState createState() => _PointsTableState(seasonName);
}

class _PointsTableState extends State<PointsTable> {

  Map teamRank={},playoff={};
  List teams=[],played=[],won=[],loss=[],tie=[],nR=[],points=[],rankIndex=[];
  final dbRef=FirebaseDatabase.instance.reference();
  bool table=true;
  String seasonName;

  _PointsTableState(this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/teams').onValue.listen((event) {
      teamRank=event.snapshot.value;
      teams.clear();
      played.clear();
      won.clear();
      loss.clear();
      tie.clear();
      points.clear();
      nR.clear();
      teamRank.keys.forEach((element) {
        teams.add(element);
        played.add(teamRank[element]['pd']);
        won.add(teamRank[element]['w']);
        loss.add(teamRank[element]['l']);
        tie.add(teamRank[element]['t']);
        points.add(teamRank[element]['pt']);
        nR.add(teamRank[element]['rr']);
      });
      rankFind();
      setState(() {

      });
    });
    dbRef.child(seasonName+'/playoff').once().then((snapShot){
      if(snapShot.value!=null){
        playoff=snapShot.value;
        setState(() {

        });
      }
    });
    super.initState();
  }

  rankFind(){
    int temp,tempRank;
    double tempNrVal;
    List tempList=[],tempNr=[];
    rankIndex.clear();
    for(int i=0;i<points.length;i++){
      tempList.add(points[i]);
      tempNr.add(nR[i]);
      rankIndex.add(i);
    }
    for(int i=0;i<points.length-1;i++){
      for(int j=i+1;j<points.length;j++){
        if(tempList[i]<tempList[j]){
          temp=tempList[i];
          tempList[i]=tempList[j];
          tempList[j]=temp;
          tempNrVal=tempNr[i].toDouble();
          tempNr[i]=tempNr[j];
          tempNr[j]=tempNrVal;
          tempRank=rankIndex[i];
          rankIndex[i]=rankIndex[j];
          rankIndex[j]=tempRank;
        }
        else if(tempList[i]==tempList[j]){
          if(tempNr[i]<tempNr[j]){
            temp=tempList[i];
            tempList[i]=tempList[j];
            tempList[j]=temp;
            tempNrVal=tempNr[i].toDouble();
            tempNr[i]=tempNr[j];
            tempNr[j]=tempNrVal;
            tempRank=rankIndex[i];
            rankIndex[i]=rankIndex[j];
            rankIndex[j]=tempRank;
          }
        }
      }
    }
  }

  Widget leagueTable(bWidth){
    return Column(
      children: [
        SizedBox(height: 1,),
        Container(
          color: Colors.black,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(child: Text("Rank",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),width: bWidth*0.1,),
              SizedBox(child: Text("Team",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.34,),
              SizedBox(child: Text("Pd",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.08,),
              SizedBox(child: Text("W",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.08,),
              SizedBox(child: Text("L",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.08,),
              SizedBox(child: Text("T",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.08,),
              SizedBox(child: Text("Pt",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.09,),
              SizedBox(child: Text("NRR",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.15,),
            ],
          ),
        ),
        SizedBox(height: 1,),
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 3)),
            color: Colors.teal[100],
          ),
          height: MediaQuery.of(context).size.height-300,
          child: ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context,i){
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0,left: 5,right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: i==4?Colors.blueGrey[600]:Colors.tealAccent[700],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                    child: Row(
                      children: [
                        SizedBox(child: Text((i+1).toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.1,),
                        SizedBox(child: Text(teams[rankIndex[i]],textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.34,),
                        SizedBox(child: Text(played[rankIndex[i]].toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.08,),
                        SizedBox(child: Text(won[rankIndex[i]].toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.08,),
                        SizedBox(child: Text(loss[rankIndex[i]].toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.08,),
                        SizedBox(child: Text(tie[rankIndex[i]].toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.08,),
                        SizedBox(child: Text(points[rankIndex[i]].toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.09,),
                        SizedBox(child: Text(nR[rankIndex[i]].toStringAsFixed(2),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.15,),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget playoffTable(bWidth){
    return Container(
      height: 500,
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreenAccent[700],
                ),
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(playoff['final']!=null?playoff['final']['winner']:"Qualifier 1 Winner",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          Container(
            height: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Final"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent,
                ),
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(playoff['final']!=null?playoff['final']['loser']:"Qualifier 2 Winner",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          SizedBox(height: 40,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreenAccent[700],
                  ),
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(playoff['qualifier1']!=null?playoff['qualifier1']['winner']:"League Rank 1",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width-340,),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreenAccent[700],
                  ),
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(playoff['qualifier2']!=null?playoff['qualifier2']['winner']:"Qualifier 1 Loser",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        width:150,
                        child: Text("Qualifier 1",textAlign: TextAlign.center,),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width-340,),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        width: 150,
                        child: Text("Qualifier 2",textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent,
                  ),
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(playoff['qualifier1']!=null?playoff['qualifier1']['loser']:"League Rank 2",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width-340,),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent,
                  ),
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(playoff['qualifier2']!=null?playoff['qualifier2']['loser']:"Eliminator Winner",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightGreenAccent[700],
                ),
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(playoff['eliminator']!=null?playoff['eliminator']['winner']:"League Rank 3",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          Container(
            height: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Eliminator"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent,
                ),
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(playoff['eliminator']!=null?playoff['eliminator']['loser']:"League Rank 4",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3),
              color: Colors.yellowAccent,
            ),
            width: MediaQuery.of(context).size.width-40,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text("Winner :",textAlign: TextAlign.end,)),
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text(playoff['final']!=null?" "+playoff['final']['winner']:"Not Declared...",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text("2nd Runner Up : ",textAlign: TextAlign.end,)),
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text(playoff['final']!=null?" "+playoff['final']['loser']:"Not Declared...",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text("3rd Runner Up : ",textAlign: TextAlign.end,)),
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text(playoff['qualifier2']!=null?" "+playoff['qualifier2']['loser']:"Not Declared...",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text("4th Runner Up : ",textAlign: TextAlign.end,)),
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text(playoff['eliminator']!=null?" "+playoff['eliminator']['loser']:"Not Declared...",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text("5th Runner Up : ",textAlign: TextAlign.end,)),
                      SizedBox(width: (MediaQuery.of(context).size.width-46)*0.5,child: Text(playoff.keys.length!=0?" "+teams[rankIndex[4]]:"Not Declared...",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bWidth=MediaQuery.of(context).size.width-14;
    return Scaffold(
      body: Container(
        color: Colors.teal[100],
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
                                Text("   Points Table",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 0,
                  bottom: 10,
                  child: Image.asset('assets/points.png'),
                ),
              ],
            ),
            table?leagueTable(bWidth):playoffTable(bWidth),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[600],
              ),
              onPressed: (){
                if(table){
                  table=false;
                }
                else{
                  table=true;
                }
                setState(() {

                });
              },
              child: Text(table?"Playoffs":"League"),
            ),
          ],
        ),
      ),
    );
  }
}
