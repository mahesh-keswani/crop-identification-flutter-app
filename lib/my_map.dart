import 'package:map_launcher/map_launcher.dart';

class ShowMaps{

  ShowMaps({this.lat, this.long, this.label, this.description});

  final double lat;
  final double long;
  final String label;
  final String description;
  String error;

  showUserMap() async{

    try{
      final availableMaps = await MapLauncher.installedMaps;
      print("Lat: $lat, long: $long");
      await availableMaps.first.showMarker(
        coords: Coords(lat, long),
        title: label,
        description: description
      );
    }
    catch(e){
      error = e.toString();
    }
  }
}