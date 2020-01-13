import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;

class ShowResults extends StatefulWidget {

  ShowResults({this.image, this.outputs});
  final image;
  final outputs;

  @override
  _ShowResultsState createState() => _ShowResultsState();
}

class _ShowResultsState extends State<ShowResults> {

  String keyword;
  String confidence;

  var wikipediaPage;

  @override
  void initState()
  {
    keyword= widget.outputs[0]["label"].toString().substring(2);
    confidence = widget.outputs[0]["confidence"].toString().substring(0, 5);
  }

  String getURL () {
    print("The url: ${wikipediaPage.url}");
    return wikipediaPage.url.toString();
  } 

  String getDescription () {

    return wikipediaPage.summary().toString();
  } 

  String getLinks () {
    return wikipediaPage.links.toString();
  } 

  setKeyword(String keyword) async{
    wikipediaPage = await wiki.page(keyword);
  }

  @override
  Widget build(BuildContext context) {
    setKeyword(keyword);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          widget.image == null ? Text("Please go back and Select an image") : Image.file(widget.image),
          widget.outputs != null
                      ? Text(
                          "Label: ${keyword} \nProbabilty: ${confidence}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            background: Paint()..color = Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ): Text("Unknown error occured, please try again"),
        
        
          
    ],
  ),
);
}
}