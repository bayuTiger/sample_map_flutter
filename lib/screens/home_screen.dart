import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/cool_spot.dart';
import '../widgets/cool_spot_card.dart';
import '../widgets/cool_spot_marker.dart';
import '../widgets/vertical_drag_zoom_gesture.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  LatLng? _startPosition;
  LatLng? _targetPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animatedMoveToSpot(LatLng targetLocation) {
    _startPosition = _mapController.center;
    _targetPosition = targetLocation;
    _animationController.reset();
    _animationController.forward();

    _animation.addListener(() {
      final double lat = _startPosition!.latitude +
          (_targetPosition!.latitude - _startPosition!.latitude) *
              _animation.value;
      final double lng = _startPosition!.longitude +
          (_targetPosition!.longitude - _startPosition!.longitude) *
              _animation.value;
      _mapController.move(LatLng(lat, lng), 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'せいかつがかり',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: VerticalDragZoomGestureDetector(
              mapController: _mapController,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(35.6812, 139.7671),
                  zoom: 13,
                  minZoom: 3,
                  maxZoom: 18,
                  interactiveFlags: InteractiveFlag.all,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: coolSpots
                        .map((spot) => Marker(
                              point: spot.location,
                              width: 150,
                              height: 80,
                              builder: (ctx) => GestureDetector(
                                onTap: () => _animatedMoveToSpot(spot.location),
                                child: CoolSpotMarker(spot: spot),
                              ),
                              anchorPos: AnchorPos.align(AnchorAlign.bottom),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: coolSpots.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CoolSpotCard(
                    spot: coolSpots[index],
                    onTap: () => _animatedMoveToSpot(coolSpots[index].location),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
