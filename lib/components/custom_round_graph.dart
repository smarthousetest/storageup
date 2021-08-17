import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyProgressIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Text("Custom Progress Indicator"),
            backgroundColor: Colors.redAccent
        ),
        body:Container(
            child:Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: CircularPercentIndicator( //circular progress indicator
                      radius: 120.0, //radius for circle
                      lineWidth: 15.0, //width of circle line
                      animation: true, //animate when it shows progress indicator first
                      percent: 60/100, //vercentage value: 0.6 for 60% (60/100 = 0.6)
                      center: Text("60.0%",style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      ), //center text, you can set Icon as well
                      footer: Text("Order this Month", style:TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                      ), //footer text
                      backgroundColor: Colors.lightGreen, //backround of progress bar
                      circularStrokeCap: CircularStrokeCap.round, //corner shape of progress bar at start/end
                      progressColor: Colors.redAccent, //progress bar color
                    )
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  child: LinearPercentIndicator( //leaner progress bar
                    width: 210, //width for progress bar
                    animation: true, //animation to show progress at first
                    animationDuration: 1000,
                    lineHeight: 30.0, //height of progress bar
                    leading: Padding( //prefix content
                      padding: EdgeInsets.only(right:15),
                      child:Text("left content"), //left content
                    ),
                    trailing: Padding( //sufix content
                      padding: EdgeInsets.only(left:15),
                      child:Text("right content"), //right content
                    ),
                    percent: 0.3, // 30/100 = 0.3
                    center: Text("30.0%"),
                    linearStrokeCap: LinearStrokeCap.roundAll, //make round cap at start and end both
                    progressColor: Colors.redAccent, //percentage progress bar color
                    backgroundColor: Colors.orange[100],  //background progressbar color
                  ),
                )
              ],
            )
        )
    );
  }

}