import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant {
  // ToDo if there are Problem will be fixing by static num getMarkerRotation in method signature and remove .toDouble()
  static double getMarkerRotation(initLat, initLng, sessionLat, sessionLng) {
    return SphericalUtil.computeHeading(LatLng(initLat, initLng), LatLng(sessionLat, sessionLng)).toDouble();
  }
}
