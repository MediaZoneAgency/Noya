import 'dart:ui';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/map/ui/map.dart';
import 'package:broker/feature/unitDetails/ui/widget/description_container.dart';
import 'package:dio/dio.dart'; // Make sure to import Dio
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import '../../../home/data/models/unit_model.dart';
import '../widget/details_bar.dart'; // Assuming this is needed for other widgets
import '../widget/image_carousel.dart';

class UnitDetailsScreen extends StatefulWidget {
  const UnitDetailsScreen({super.key, required this.unit});
  final UnitModel unit;

  @override
  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> {
  LatLng? _coordinates;
  bool _isLoadingLocation = true;
  String? _mapStyle;
  BitmapDescriptor? customMarkerIcon;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _loadCustomMarker();
    if (widget.unit.location != null) {
      _fetchCoordinatesFromUrl(widget.unit.location!);
    } else {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  /// ✅ This is the corrected, asynchronous function to get coordinates
  Future<void> _fetchCoordinatesFromUrl(String shortUrl) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        shortUrl,
        options: Options(
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 400,
        ),
      );

      final fullUrl = response.headers.value('location');
      if (fullUrl == null) {
        throw Exception("'location' header not found.");
      }

      // Try to extract from format: @lat,lng
      var regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
      var match = regex.firstMatch(fullUrl);

      if (match != null && match.groupCount >= 2) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null) {
          setState(() {
            _coordinates = LatLng(lat, lng);
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // Fallback for format: ?q=lat,lng or daddr=lat,lng
      final uri = Uri.parse(fullUrl);
      final queryParam =
          uri.queryParameters['q'] ?? uri.queryParameters['daddr'];
      if (queryParam != null) {
        final parts = queryParam.split(',');
        if (parts.length >= 2) {
          final lat = double.tryParse(parts[0]);
          final lng = double.tryParse(parts[1]);
          if (lat != null && lng != null) {
            setState(() {
              _coordinates = LatLng(lat, lng);
              _isLoadingLocation = false;
            });
            return;
          }
        }
      }

      throw Exception("Could not parse coordinates from URL.");
    } catch (e) {
      print("Failed to resolve or parse coordinates: $e");
      setState(() {
        _isLoadingLocation = false; // Stop loading even if there's an error
      });
    }
  }

  Future<void> _loadCustomMarker() async {
    final bitmap = await getMarkerIconFromAsset('assets/img/Group 94 (1).png');
    setState(() => customMarkerIcon = bitmap);
  }

  Future<BitmapDescriptor> getMarkerIconFromAsset(String path,
      {int width = 100}) async {
    final ByteData byteData = await rootBundle.load(path);
    final Uint8List imageData = byteData.buffer.asUint8List();
    final ui.Codec codec =
        await ui.instantiateImageCodec(imageData, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedByteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = resizedByteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImageData);
  }

  /// Opens the original link in an external map app
  Future<void> _openInExternalMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _loadMapStyle() async {
    try {
      _mapStyle = await rootBundle.loadString('assets/map_style.json');
    } catch (e) {
      print("Error loading map style: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            widget.unit.type ?? "not valid type",
                            style: TextStyles.urbanistSemiBold18Light,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            // It seems you're showing 'type' again here. Maybe a different field?
                            widget.unit.type ?? "not valid location",
                            style: TextStyles.urbanistMedium14Light,
                          ),
                          ImageCarousel(imgList: widget.unit.images ?? []),
                          const SizedBox(height: 20),
                          DetailsContainer(
                            bedroom: widget.unit.rooms ?? 0,
                            bathroom: widget.unit.bathrooms ?? 0,
                            space: widget.unit.size ?? 0,
                            description: widget.unit.description ??
                                "didn't have description",
                            price: widget.unit.price ?? "0",
                          ),
                          const SizedBox(height: 36),

                          // ✅ Location Section with loading and fallback
                          if (widget.unit.location != null) ...[
                            if (_isLoadingLocation)
                              const Center(child: CircularProgressIndicator())
                            else if (_coordinates != null)
                              SizedBox(
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: GoogleMap(
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      if (_mapStyle != null) {
                                        controller.setMapStyle(_mapStyle);
                                      }
                                    },
                                    initialCameraPosition: CameraPosition(
                                      target: _coordinates!,
                                      zoom: 14,
                                    ),
                                    markers: {
                                      Marker(
                                          markerId:
                                              const MarkerId('unit_location'),
                                          position: _coordinates!,
                                          // استخدم الأيقونة المخصصة، مع توفير أيقونة افتراضية كخطة بديلة
                                          icon: customMarkerIcon ??
                                              BitmapDescriptor.defaultMarker,
                                          onTap: () {
                                            if (_coordinates != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  // ✅ استدعاء الشاشة الجديدة
                                                  builder: (context) =>
                                                      RouteMapScreen(
                                                    destination: _coordinates!,
                                                    destinationTitle:
                                                        widget.unit.type ??
                                                            "Property Location",
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    },
                                    zoomControlsEnabled: false,
                                    myLocationButtonEnabled: false,
                                  ),
                                ),
                              )
                            else // Fallback button if coordinates couldn't be fetched
                              Center(
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _openInExternalMap(widget.unit.location!),
                                  icon: const Icon(Icons.map_outlined,
                                      color: Colors.white),
                                  label: const Text(
                                    "الموقع غير متوفر، افتح في الخريطة",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 36),
                          ],
                        ],
                      ),
                    ),

                    // Close Button
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
