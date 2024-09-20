import 'package:breniki/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();
  LatLng? startPoint;
  LatLng? endPoint;
  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 13,
                    ),
                    markers: _createMarkers(),
                    onTap: (LatLng position) {
                      _handleMapTap(position);
                    },
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
            if (startPoint != null && endPoint != null)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    final coordinates = await fetchPolylinePoints();
                    generatePolyLineFromPoints(coordinates);
                  },
                  child: const Icon(Icons.directions),
                ),
              ),
          ],
        ),
      );

  Set<Marker> _createMarkers() {
    final markers = <Marker>{};

    if (currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          icon: BitmapDescriptor.defaultMarker,
          position: currentPosition!,
        ),
      );
    }

    if (startPoint != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('startLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: startPoint!,
        ),
      );
    }

    if (endPoint != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('endLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: endPoint!,
        ),
      );
    }

    return markers;
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      if (startPoint == null) {
        startPoint = tappedPoint;
      } else if (endPoint == null) {
        endPoint = tappedPoint;
      } else {
        // Reset if both points are already set
        startPoint = tappedPoint;
        endPoint = null;
        polylines.clear();
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    if (startPoint == null || endPoint == null) {
      return [];
    }

    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(startPoint!.latitude, startPoint!.longitude),
      PointLatLng(endPoint!.latitude, endPoint!.longitude),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 46, 46, 46),
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }
}
