import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TopBatsman extends StatefulWidget {

  String seasonName;

  TopBatsman(this.seasonName);

  @override
  _TopBatsmanState createState() => _TopBatsmanState(seasonName);
}

class _TopBatsmanState extends State<TopBatsman> {

  Map playerRuns={};
  List rankList=[];
  List runs=[],avg=[],team=[],rankIndex=[];
  var cardColor=Colors.cyanAccent[700];
  String seasonName;

  final dbRef=FirebaseDatabase.instance.reference();

  _TopBatsmanState(this.seasonName);

  @override
  void initState(){
    dbRef.child(seasonName+'/players').once().then((snapshot){
      playerRuns=snapshot.value;
      playerRuns.forEach((key,val) {
        if(val['runs']!=0){
          rankList.add(key);
          runs.add(val['runs']);
          avg.add(val['avg']);
          team.add(val['team']);
        }
      });
      rankFind();
      setState(() {

      });
    });
    super.initState();
  }

  rankFind(){
    int temp,tempRank;
    double tempAvg;
    List tempList=[],tempAvgList=[];
    for(int i=0;i<rankList.length;i++){
      tempList.add(runs[i]);
      tempAvgList.add(avg[i]);
      rankIndex.add(i);
    }
    for(int i=0;i<rankList.length-1;i++){
      for(int j=i+1;j<rankList.length;j++){
        if(tempList[i]<tempList[j]){
          temp=tempList[i];
          tempList[i]=tempList[j];
          tempList[j]=temp;
          tempAvg=tempAvgList[i].toDouble();
          tempAvgList[i]=tempAvgList[j].toDouble();
          tempAvgList[j]=tempAvg;
          tempRank=rankIndex[i];
          rankIndex[i]=rankIndex[j];
          rankIndex[j]=tempRank;
        }
        else if(tempList[i]==tempList[j]){
          if(tempAvgList[i]<tempAvgList[j]){
            temp=tempList[i];
            tempList[i]=tempList[j];
            tempList[j]=temp;
            tempAvg=tempAvgList[i];
            tempAvgList[i]=tempAvgList[j];
            tempAvgList[j]=tempAvg;
            tempRank=rankIndex[i];
            rankIndex[i]=rankIndex[j];
            rankIndex[j]=tempRank;
          }
        }
      }
    }
  }

  setCardColor(String teamName){
    if(seasonName=='ypl2021'){
      switch(teamName){
        case 'Saraswathi GFU':
          cardColor=Colors.orange[600];
          break;
        case 'Sanchit X1':
          cardColor=Colors.lightBlue[900];
          break;
        case 'J7 Sports':
          cardColor=Colors.yellowAccent[700];
          break;
        case 'Samarth Friends':
          cardColor=Colors.blue;
          break;
        case 'G - Bros':
          cardColor=Colors.deepPurple;
      }
    }
    else{
      switch(teamName){
        case 'Saraswathi GFU':
          cardColor=Colors.yellow[600];
          break;
        case 'Shlagya':
          cardColor=Colors.indigo[900];
          break;
        case 'Durga Cricketers':
          cardColor=Colors.blueAccent[700];
          break;
        case 'Royal Rockers':
          cardColor=Colors.lightBlueAccent;
          break;
        case 'SNG':
          cardColor=Colors.limeAccent[700];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double bWidth=MediaQuery.of(context).size.width-14;
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
                                Text("     Top Batsmen",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
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
                  right: 10,
                  bottom: 10,
                  child: Image.asset('assets/batsman.png'),
                ),
              ],
            ),
            SizedBox(height: 1,),
            Container(
              color: Colors.black,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(child: Text("Rank",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.2,),
                  SizedBox(child: Text("Batsman",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.45,),
                  SizedBox(child: Text("Runs",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),width: bWidth*0.35,),
                ],
              ),
            ),
            SizedBox(height: 1,),
            Container(
              height: MediaQuery.of(context).size.height-192,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 3,
                  ),
                ),
                color: Colors.teal[100],
              ),
              child: ListView.builder(
                itemCount: rankList.length,
                itemBuilder: (context,i){
                  setCardColor(team[rankIndex[i]]);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0,left: 5,right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: cardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                        child: Row(
                          children: [
                            SizedBox(child: Text((i+1).toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.2,),
                            SizedBox(
                              child: Column(
                                children: [
                                  Text(rankList[rankIndex[i]],textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                  SizedBox(height: 2,),
                                  Text(team[rankIndex[i]],style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 14,),),
                                ],
                              ),
                              width: bWidth*0.45,
                            ),
                            SizedBox(child: Text(runs[rankIndex[i]].toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),width: bWidth*0.35,),
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