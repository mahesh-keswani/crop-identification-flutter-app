import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'show_results.dart';
import 'package:tflite/tflite.dart';

bool _loading;
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File _image;
  List _outputs;
  List top3;
  
  @override
  void initState(){
    super.initState();
    _loading = true;
    
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  // final _imageUrls = [
  //   "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_7973.jpg",
  //   "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8427.jpg",
  //   "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8296.jpg",
  //   "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8691.jpg"
  // ];

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      classifyImage(image);
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.3,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      //Declare List _outputs in the class which will be used to show the classified classs name and confidence
      _outputs = output;
      
      print(output);

    });

    showDifferentPage(image);
  }

  void showDifferentPage(File image){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowResults(image: image, outputs: _outputs)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
      //   Container(
      //     child: ImageSliderWidget(
      //       imageUrls: _imageUrls,
      //       imageBorderRadius: BorderRadius.circular(8.0),
      //   )
      // )
      Center(
        child: RaisedButton(

          elevation: 15,
          padding: EdgeInsets.all(20),
          onPressed: getImage,
          child: Text(
            "Identify Crop",
            style: TextStyle(
              fontSize: 16
            ),
          ),
          color: Colors.blue
        ) ,
      )
      ]
    );
  }
}
