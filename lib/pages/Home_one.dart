import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multimedia/pages/Home.dart';
import 'Screen_three.dart';
import 'TileModel.dart';
import 'data.dart';
import 'level4.dart';
import 'package:audioplayers/audio_cache.dart';


class Home_one extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home_one> {
  List<TileModel> gridViewTiles = new List<TileModel>();
  List<TileModel> questionPairs = new List<TileModel>();
  var player = AudioCache();

  @override
  void initState() {
   // player.play('song.mp3');
    super.initState();
    reStart();
  }
  void reStart() {
    //player.play('song.mp3');
    myPairs = getPairs();
    myPairs.shuffle();

    gridViewTiles = myPairs;
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        print("2 seconds done");
        questionPairs = getQuestionPairs();
        gridViewTiles = questionPairs;
        selected = false;
        player.play('song.mp3');
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer : Drawer(
  child: ListView(
    children: <Widget>[
      DrawerHeader(
        child: Center(child: Text('Levels',
        style: TextStyle(fontSize: 40,color: Colors.black),
        )),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
        ),
      ),
      ListTile(
        title: Text('level 1'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
               return Home();
             }));
        },
      ),
      ListTile(
        title: Text('level 2'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
                return Screen_three();
              }));
        },
      ),
      ListTile(
        title: Text('level 4'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
                return level4();
              }));
        },
      ),
    ],
  ),
),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              points != 800 ? Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$points/800",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Points",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ],
              ) : Container(),
              SizedBox(
                height: 20,
              ),
              points != 800 ? GridView(
                shrinkWrap: true,
                //physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
                children: List.generate(gridViewTiles.length, (index) {
                  return Tile(
                    imagePathUrl: gridViewTiles[index].getImageAssetPath(),
                    tileIndex: index,
                    parent: this,
                  );
                }),
              ) : Container(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            points = 0;
                            reStart();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text("Replay", style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text("Rate Us", style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}



class Tile extends StatefulWidget {
  String imagePathUrl;
  int tileIndex;
  _HomeState parent;

  Tile({this.imagePathUrl, this.tileIndex, this.parent});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() {
            myPairs[widget.tileIndex].setIsSelected(true);
          });
          if (selectedTile != "") {
            /// testing if the selected tiles are same
            if (selectedTile == myPairs[widget.tileIndex].getImageAssetPath()) {
              print("add point");
              points = points + 100;
              print(selectedTile + " thishis" + widget.imagePathUrl);

              TileModel tileModel = new TileModel();
              print(widget.tileIndex);
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                tileModel.setImageAssetPath("");
                myPairs[widget.tileIndex] = tileModel;
                print(selectedIndex);
                myPairs[selectedIndex] = tileModel;
                this.widget.parent.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
            } else {
              print(selectedTile +
                  " thishis " +
                  myPairs[widget.tileIndex].getImageAssetPath());
              print("wrong choice");
              print(widget.tileIndex);
              print(selectedIndex);
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                this.widget.parent.setState(() {
                  myPairs[widget.tileIndex].setIsSelected(false);
                  myPairs[selectedIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });

              selectedTile = "";
            }
          } else {
            setState(() {
              selectedTile = myPairs[widget.tileIndex].getImageAssetPath();
              selectedIndex = widget.tileIndex;
            });

            print(selectedTile);
            print(selectedIndex);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: myPairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(myPairs[widget.tileIndex].getIsSelected()
            ? myPairs[widget.tileIndex].getImageAssetPath()
            : widget.imagePathUrl)
            : Container(
          color: Colors.white,
          child: Image.asset("assets/correct.png"),
        ),
      ),
    );
  }
}