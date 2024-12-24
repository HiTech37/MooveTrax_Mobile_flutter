import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
  final String name;
  final String color;
  final String deviceId;
  final String category;
  final LatLng latLng;
  final int index;
  final int acc;

  Place(
      {required this.name,
      required this.latLng,
      required this.deviceId,
      this.category = 'Default',
      required this.index,
      this.color = 'Green',
      this.acc = 0});

  @override
  LatLng get location => latLng;

  Place updateLocation(LatLng newLatLng) {
    return Place(
        name: name,
        latLng: newLatLng,
        deviceId: deviceId,
        category: category,
        index: index,
        color: color,
        acc: acc);
  }
}
