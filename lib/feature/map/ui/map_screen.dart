import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';

// class ChatLocationPreview extends StatefulWidget {
//   final double latitude;
//   final double longitude;

//   const ChatLocationPreview({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//   });

//   @override
//   State<ChatLocationPreview> createState() => _ChatLocationPreviewState();
// }

// class _ChatLocationPreviewState extends State<ChatLocationPreview> {
//   LatLng? _currentLocation;
//   double? _distanceInKm;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     final permission = await Geolocator.requestPermission();
//     final position = await Geolocator.getCurrentPosition();

//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//     });

//     _calculateDistance();
//   }

//   void _calculateDistance() {
//     if (_currentLocation == null) return;

//     final distance = Geolocator.distanceBetween(
//       _currentLocation!.latitude,
//       _currentLocation!.longitude,
//       widget.latitude,
//       widget.longitude,
//     );

//     setState(() {
//       _distanceInKm = distance / 1000;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 160,
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.grey[200],
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(widget.latitude, widget.longitude),
//                 zoom: 14,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("shared"),
//                   position: LatLng(widget.latitude, widget.longitude),
//                 ),
//               },
//               zoomControlsEnabled: false,
//               myLocationEnabled: true,
//               liteModeEnabled: true,
//               onTap: (_) {
//                 // optional: navigate to full map screen
//               },
//             ),
//           ),
//           if (_distanceInKm != null)
//             Positioned(
//               right: 12,
//               top: 12,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.7),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "${_distanceInKm!.toStringAsFixed(2)} كم",
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
// class ChatLocationPreview extends StatelessWidget {
//   final String locationLink;

//   const ChatLocationPreview({
//     super.key,
//     required this.locationLink,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 160,
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.grey[200],
//       ),
//       child: Center(
//         child: ElevatedButton.icon(
//           onPressed: () async {
//             if (await canLaunchUrl(Uri.parse(locationLink))) {
//               await launchUrl(Uri.parse(locationLink), mode: LaunchMode.externalApplication);
//             }
//           },
//           icon: const Icon(Icons.location_on),
//           label: const Text("افتح الموقع"),
//         ),
//       ),
//     );
//   }
// }






// class ChatLocationPreviewMap extends StatefulWidget {
//   final String locationLink;

//   const ChatLocationPreviewMap({super.key, required this.locationLink});

//   @override
//   State<ChatLocationPreviewMap> createState() => _ChatLocationPreviewMapState();
// }

// class _ChatLocationPreviewMapState extends State<ChatLocationPreviewMap> {
//   LatLng? _location;
//   bool _isLoading = true;
//   GoogleMapController? _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCoordinates();
//   }

//   Future<void> _fetchCoordinates() async {
//     try {
//       final uri = Uri.parse(widget.locationLink);
//       final query = uri.queryParameters['q'] ?? '';
//       final parts = query.split(',');
//       if (parts.length == 2) {
//         final lat = double.tryParse(parts[0]);
//         final lng = double.tryParse(parts[1]);
//         if (lat != null && lng != null) {
//           setState(() {
//             _location = LatLng(lat, lng);
//             _isLoading = false;
//           });
//         }
//       }
//     } catch (_) {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _applyMapStyle() async {
//     final style = await rootBundle.loadString('assets/map_style.json');
//     // ignore: deprecated_member_use
//     _mapController?.setMapStyle(style);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading || _location == null) {
//       return const Padding(
//         padding: EdgeInsets.all(12),
//         child: CircularProgressIndicator(),
//       );
//     }

//     return Container(
//       height: 180,
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: _location!,
//             zoom: 15,
//           ),
//           markers: {
//             Marker(markerId: const MarkerId("loc"), position: _location!)
//           },
//           liteModeEnabled: true,
//           zoomControlsEnabled: false,
//           myLocationEnabled: false,
//           onMapCreated: (controller) {
//             _mapController = controller;
//             _applyMapStyle();
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatLocationPreviewMap extends StatefulWidget {
  final String locationLink;

  const ChatLocationPreviewMap({super.key, required this.locationLink});

  @override
  State<ChatLocationPreviewMap> createState() => _ChatLocationPreviewMapState();
}

class _ChatLocationPreviewMapState extends State<ChatLocationPreviewMap> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadWebView(widget.locationLink);
  }

  void _loadWebView(String url) {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => isLoading = true),
            onPageFinished: (_) => setState(() => isLoading = false),
            onWebResourceError: (error) {
              setState(() {
                hasError = true;
                isLoading = false;
              });
              _openInExternalApp(widget.locationLink);
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      _openInExternalApp(widget.locationLink);
    }
  }

  Future<void> _openInExternalApp(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            if (!hasError)
              WebViewWidget(controller: _controller)
            else
              const Center(
                child: Text(
                  'تعذر تحميل الخريطة',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
