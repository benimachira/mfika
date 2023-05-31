import 'package:flutter/foundation.dart';


import '../models/bus_location.dart';
import '../samples/sample_data.dart';

class BusLocationProvider with ChangeNotifier {
  List<BusLocation> _busLocations = [];

  List<BusLocation> get busLocations => _busLocations;

  void fetchBusLocations() {
    _busLocations.clear();

    for (var busLocationData in sampleData['busLocations']) {
      _busLocations.add(BusLocation.fromJson(busLocationData));
    }

    notifyListeners();
  }
}


// import '../models/bus_location.dart';
//
// class BusLocationProvider with ChangeNotifier {
//   BusLocation _busLocation = BusLocation(latitude: 0, longitude: 0);
//
//   BusLocation get busLocation => _busLocation;
//
//   void updateBusLocation(BusLocation newBusLocation) {
//     _busLocation = newBusLocation;
//     notifyListeners();
//   }
// }
