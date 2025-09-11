// file: lib/feature/.../route_map_screen.dart

import 'dart:async';
import 'dart:ui' as ui;
import 'package:broker/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // إذا كنت تستخدمه

class RouteMapScreen extends StatefulWidget {
  final LatLng destination;
  final String destinationTitle;

  const RouteMapScreen({
    super.key,
    required this.destination,
    required this.destinationTitle,
  });

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  final String apiKey = "AIzaSyAGMmXcsZm2wBqNW9A7xuTF3eTOxTU6_Co"; // 👈 استبدل بمفتاحك
  
  bool _isLoading = true;
  String? _mapStyle;
  BitmapDescriptor? destinationMarkerIcon;
  GoogleMapController? _mapController;

  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Map<String, String>? _travelInfo;

  @override
  void initState() {
    super.initState();
    _loadAssetsAndInitializeRoute();
  }
  
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadAssetsAndInitializeRoute() async {
    // Load map style and custom marker in parallel
    await Future.wait([
      _loadMapStyle(),
      _loadCustomMarker(),
    ]);
    
    // After assets are loaded, get location and draw the route
    await _initializeRoute();
    
    setState(() => _isLoading = false);
  }

  Future<void> _loadMapStyle() async {
    try {
      _mapStyle = await rootBundle.loadString('assets/map_style.json');
    } catch (e) {
      print("Error loading map style: $e");
    }
  }

  Future<void> _loadCustomMarker() async {
    try {
      destinationMarkerIcon = await getMarkerIconFromAsset('assets/img/Group 94 (1).png', width: 120);
    } catch (e) {
      print("Error loading custom marker: $e");
    }
  }

  Future<void> _initializeRoute() async {
    try {
      await _getCurrentLocation();
      
      if (_currentLocation != null) {
        // Add markers for current location and destination
        _addMarkers(_currentLocation!, widget.destination);
        // Fetch route info and draw polyline
        await _getTravelInfo(_currentLocation!, widget.destination);
        // Animate camera to fit the route
        _fitRouteOnScreen(_currentLocation!, widget.destination);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled.");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentLocation = LatLng(position.latitude, position.longitude);
  }
  
  void _addMarkers(LatLng origin, LatLng destination) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination_marker'),
          position: destination,
          icon: destinationMarkerIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: widget.destinationTitle),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('origin_marker'),
          position: origin,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: "موقعك الحالي"),
        ),
      );
    });
  }
Future<void> _getTravelInfo(LatLng origin, LatLng destination) async {
  final url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

  try {
    final response = await Dio().get(url);
    final data = response.data;
    
    // 👇 اطبع الاستجابة بالكامل هنا
    print("Directions API Response: $data");

    if (data['status'] == 'OK' && (data['routes'] as List).isNotEmpty) {
      final route = data['routes'][0];
      final leg = route['legs'][0];

      setState(() {
        _travelInfo = {'duration': leg['duration']['text'], 'distance': leg['distance']['text']};
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: _decodePolyline(route['overview_polyline']['points']), // تأكد أن هذه الدالة موجودة
            color: const Color(0xFF00FFD1), // لون مميز
            width: 5,
          ),
        );
      });
    } else {
        // إذا كانت الاستجابة ليست OK، اطبع الحالة لمعرفة السبب
        print("Directions API Error Status: ${data['status']}");
        print("Error Message: ${data['error_message']}");
    }
  } catch (e) {
    // إذا حدث خطأ في الاتصال نفسه
    print("Dio Error fetching travel info: $e");
  }
}
 void _fitRouteOnScreen(LatLng p1, LatLng p2) {
    // Add a short delay to ensure the map controller is ready
    Future.delayed(const Duration(milliseconds: 100), () {
        LatLngBounds bounds;
        if (p1.latitude > p2.latitude) {
            bounds = LatLngBounds(southwest: p2, northeast: p1);
        } else {
            bounds = LatLngBounds(southwest: p1, northeast: p2);
        }

        CameraUpdate u = CameraUpdate.newLatLngBounds(bounds, 50.0);
        _mapController?.animateCamera(u);
    });
  }

  // --- Helper Functions ---
  Future<BitmapDescriptor> getMarkerIconFromAsset(String path, {int width = 100}) async {
    final ByteData byteData = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedByteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedByteData!.buffer.asUint8List());
  }

 
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destinationTitle,style: TextStyles.inter22BoldWhite.copyWith(fontSize: 18),),
        backgroundColor: Color(0xFF063A34),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              if (_mapStyle != null) {
                _mapController!.setMapStyle(_mapStyle);
              }
            },
            initialCameraPosition: CameraPosition(target: widget.destination, zoom: 11),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false, // We use a custom marker for current location
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_travelInfo != null)
             _buildTravelInfoCard(),
        ],
      ),
    );
  }
  Widget _buildTravelInfoCard() {
  return Positioned(
    bottom: 20,
    left: 16,
    right: 16,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xDD063A34),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Travel Time
          _buildInfoColumn(
            Icons.timer_outlined,
            "الوقت",
            _travelInfo?['duration'] ?? '--',
          ),
          // Travel Distance
          _buildInfoColumn(
            Icons.route_outlined,
            "المسافة",
            _travelInfo?['distance'] ?? '--',
          ),
        ],
      ),
    ),
  );
}

// دالة مساعدة لجعل الكود أنظف
Widget _buildInfoColumn(IconData icon, String title, String value) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: const Color(0xFF00FFD1), size: 28),
      const SizedBox(height: 8),
      Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
}