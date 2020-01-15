import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'get_data.dart';
import 'package:share/share.dart';
import 'handle_location.dart';
import 'my_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore    
import 'package:path/path.dart' as Path; 
import 'package:rflutter_alert/rflutter_alert.dart';



final _firestore = Firestore.instance;

class ShowResults extends StatefulWidget {

  ShowResults({this.image, this.outputs});
  final File image;
  final outputs;
  Map body;

  @override
  _ShowResultsState createState() => _ShowResultsState();
}

class _ShowResultsState extends State<ShowResults> {

  String keyword;
  String confidence;

  double lat;
  double long;
  String _uploadedFileURL;
  String error;

  HandleLocation location;
  @override
  void initState()
  {
    keyword= widget.outputs[0]["label"].toString().substring(2);
    confidence = widget.outputs[0]["confidence"].toString().substring(0, 5);
  }

  void share(BuildContext context , String text){
    final RenderBox box = context.findRenderObject();

    Share.share(text, subject: "New crop clicked", sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future uploadFile() async {    
    try{
      StorageReference storageReference = FirebaseStorage.instance    
        .ref()    
        .child('${Path.basename(widget.image.path)}}${DateTime.now()}');    
    StorageUploadTask uploadTask = storageReference.putFile(widget.image);    
    await uploadTask.onComplete;    

    storageReference.getDownloadURL().then((fileURL) {    
      setState(() {    
        
        _uploadedFileURL = fileURL; 
        print(_uploadedFileURL);   
      });    
    });
    }
    catch(e){
      setState((){
        error = e.toString();
      });
      
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          widget.image == null ? Text("Please go back and Select an image") : Image.file(widget.image),
          Padding(
            padding: const EdgeInsets.all(15),
          ),
          Container(
            child: widget.outputs != null
                      ? Text(
                          "Label:               ${keyword} \nProbabilty:       ${confidence}",

                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ): Text("Unknown error occured, please try again", style: TextStyle(color: Colors.redAccent),),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 3.0))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue)
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Description",
                  style: TextStyle(fontSize: 25, color: Colors.green, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                ),
                Text(
                  GetData().getData(keyword),
                  style: TextStyle(
                    fontSize: 15,                    
                  ),
                  
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      color: Colors.lightBlue,
                      child: Text("Share"),
                      onPressed: () async{
                        location = HandleLocation();
                        await location.getLocation();
                        setState(() {
                          lat = location.latitude;
                          long = location.longitude;
                        });
                        share(context, "Crop: $keyword\nLocation: $lat, $long \n With Probability: $confidence");
                        // String BASE64_IMAGE = Image.file(widget.image).toString();
                        // AdvancedShare.generic(
                        //     msg: "Crop: $keyword\nLocation: $lat, $long \n With Probability: $confidence", 
                        //     subject: "New crop identification",
                        //     title: "Share Crop Image",
                        //     url: BASE64_IMAGE
                        //   ).then((response){
                        //   print(response);
                        //   });
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      color: Colors.lightGreen,
                      child: Text("See Map"),
                      onPressed: () async{

                        location = HandleLocation();
                        await location.getLocation();
                        setState(() {
                          lat = location.latitude;
                          long = location.longitude;
                        });
                        ShowMaps map = ShowMaps(lat: lat, long: long, label: keyword, description: GetData().getData(keyword));

                        map.showUserMap();
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      color: Colors.blueAccent,
                      child: Text("Save"),
                      onPressed: () async{
                        location = HandleLocation();
                          await location.getLocation();

                          location.error != null ? Alert(context: context, title: "Error", desc: "Error in getting location, try restarting app").show() : null;

                            setState(() {
                              lat = location.latitude;
                              long = location.longitude;
                            });
                          uploadFile();
                          
                        _firestore.collection('crops').add({
                          
                        'name' : keyword,
                        'lat' : lat,
                        'long': long,
                        'image': _uploadedFileURL
                      });
                      error != null ? Alert(context: context, title: "Error", desc: "Error in getting location, try restarting app").show() : Alert(context: context, title: "Yay", desc: "Data uploaded successfuly").show();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        
          
    ],
  ),
);
}
}
