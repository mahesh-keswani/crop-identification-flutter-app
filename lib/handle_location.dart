import 'package:geolocator/geolocator.dart';

class HandleLocation{

  double latitude;
  double longitude;

  Future<void> getLocation() async {
    try{
      // as the accuracy is set to high, then the app becomes very battery intensive
      // Therefore, inorder to get the weather of a location then accurate position is not required
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      latitude = position.latitude;
      longitude = position.longitude;

      // print("Inside location $position");
      // print(latitude);
      // print(longitude);
    }
    catch(e){
      print(e);
    }
  }
}