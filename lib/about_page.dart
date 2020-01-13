import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    List crops = ["Wheat", "Mustard", "Banana", "Rice", "Chilly", "Cucumbar", "Wheat", "Cabbage", "Cotton", "Onion", "Corn", "Tomato"];
    return Scaffold(
      body: ListView(
        children: crops.map( 
          (var crop) => ListTile(            
            title: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(15)
            ),
              child: Text(
                crop,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          )).toList(),          
      ),
    );
  }
}