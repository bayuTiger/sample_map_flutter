import 'dart:math';
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
  List<CoolSpot> _spots = List.from(coolSpots);
  final Random _random = Random();

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

  void _addNewSpot() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newSpotName = '';
        String newSpotDescription = '';
        return AlertDialog(
          title: Text('新しいスポットを追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: "スポット名"),
                onChanged: (value) {
                  newSpotName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: "説明"),
                onChanged: (value) {
                  newSpotDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('追加'),
              onPressed: () {
                if (newSpotName.isNotEmpty) {
                  final newSpot = CoolSpot(
                    name: newSpotName,
                    description: newSpotDescription,
                    location: LatLng(
                      35.6812 + (_random.nextDouble() - 0.5) * 0.1,
                      139.7671 + (_random.nextDouble() - 0.5) * 0.1,
                    ),
                    imageUrl: 'assets/images/default.jpg',
                    rating: 0.0,
                  );
                  setState(() {
                    _spots.add(newSpot);
                  });
                  _animatedMoveToSpot(newSpot.location);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '涼スポットファインダー',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  VerticalDragZoomGestureDetector(
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
                          markers: _spots
                              .map((spot) => Marker(
                                    point: spot.location,
                                    width: 150,
                                    height: 80,
                                    builder: (ctx) => GestureDetector(
                                      onTap: () =>
                                          _animatedMoveToSpot(spot.location),
                                      child: CoolSpotMarker(spot: spot),
                                    ),
                                    anchorPos:
                                        AnchorPos.align(AnchorAlign.bottom),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _addNewSpot,
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 240, 
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _spots.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 250,
                      child: CoolSpotCard(
                        spot: _spots[index],
                        onTap: () =>
                            _animatedMoveToSpot(_spots[index].location),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
