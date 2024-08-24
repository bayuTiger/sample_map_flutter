import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class VerticalDragZoomGestureRecognizer extends VerticalDragGestureRecognizer {
  final MapController mapController;
  final double sensitivity;

  VerticalDragZoomGestureRecognizer({
    required this.mapController,
    this.sensitivity = 0.01,
  }) {
    onUpdate = _handleDragUpdate;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    final currentZoom = mapController.zoom;
    final newZoom = currentZoom - delta * sensitivity;
    mapController.move(mapController.center, newZoom.clamp(3.0, 18.0));
  }
}

class VerticalDragZoomGestureDetector extends StatelessWidget {
  final MapController mapController;
  final Widget child;

  const VerticalDragZoomGestureDetector({
    Key? key,
    required this.mapController,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragZoomGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            VerticalDragZoomGestureRecognizer>(
          () => VerticalDragZoomGestureRecognizer(mapController: mapController),
          (VerticalDragZoomGestureRecognizer instance) {},
        ),
      },
      child: child,
    );
  }
}
