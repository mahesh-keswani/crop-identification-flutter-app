import 'package:cropidentification/get_data.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class AboutPage extends StatefulWidget { 
  
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {

    List<String> crops = [ "Mustard", "Banana", "Rice", "Chilly", "Cucumbar", "Cabbage", "Cotton", "Onion", "Corn", "Tomato"];
    return Scaffold(
      
      body: ListView(
        
        children: crops.map( 
          (String crop) => Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blue, width: 3.0))
            ),
            child: ExpandablePanel(
                          
              header: Text(crop, textAlign: TextAlign.center ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
              collapsed: Text(GetData().getData(crop), style: TextStyle(fontSize: 15), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              expanded: Text(GetData().getData(crop), softWrap: true, ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          )).toList(),          
      ),
    );
  }
}