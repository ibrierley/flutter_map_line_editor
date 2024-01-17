import 'package:flutter/widgets.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

class PolyEditor {
  final List<LatLng> points;
  final Widget pointIcon;
  final Size pointIconSize;
  final Widget? intermediateIcon;
  final Size intermediateIconSize;
  final void Function(LatLng? updatePoint)? callbackRefresh;
  final bool addClosePathMarker;

  PolyEditor({
    required this.points,
    required this.pointIcon,
    this.intermediateIcon,
    this.callbackRefresh,
    this.addClosePathMarker = false,
    this.pointIconSize = const Size(30, 30),
    this.intermediateIconSize = const Size(30, 30),
  });

  int? _markerToUpdate;

  void updateMarker(details, point) {
    if (_markerToUpdate != null) {
      points[_markerToUpdate!] = LatLng(point.latitude, point.longitude);
    }
    callbackRefresh?.call(LatLng(point.latitude, point.longitude));
  }

  List add(List<LatLng> pointsList, point) {
    pointsList.add(point);
    callbackRefresh?.call(point);
    return pointsList;
  }

  LatLng remove(int index) {
    final point = points.removeAt(index);
    callbackRefresh?.call(null);
    return point;
  }

  List<DragMarker> edit() {
    List<DragMarker> dragMarkers = [];

    for (var c = 0; c < points.length; c++) {
      final indexClosure = c;
      dragMarkers.add(DragMarker(
        point: points[c],
        size: pointIconSize,
        builder: (_, __, ___) => pointIcon,
        onDragStart: (_, __) => _markerToUpdate = indexClosure,
        onDragUpdate: updateMarker,
        onLongPress: (ll) => remove(indexClosure),
      ));
    }

    for (var c = 0; c < points.length - 1; c++) {
      final polyPoint = points[c];
      final polyPoint2 = points[c + 1];

      if (intermediateIcon != null) {
        final indexClosure = c;
        final intermediatePoint = LatLng(
            polyPoint.latitude + (polyPoint2.latitude - polyPoint.latitude) / 2,
            polyPoint.longitude +
                (polyPoint2.longitude - polyPoint.longitude) / 2);

        dragMarkers.add(DragMarker(
          point: intermediatePoint,
          size: intermediateIconSize,
          builder: (_, __, ___) => intermediateIcon!,
          onDragStart: (details, point) {
            points.insert(indexClosure + 1, intermediatePoint);
            _markerToUpdate = indexClosure + 1;
          },
          onDragUpdate: updateMarker,
        ));
      }
    }

    /// Final close marker from end back to beginning we want if its a closed polygon.
    if (addClosePathMarker && (points.length > 2)) {
      if (intermediateIcon != null) {
        final finalPointIndex = points.length - 1;

        final intermediatePoint = LatLng(
            points[finalPointIndex].latitude +
                (points[0].latitude - points[finalPointIndex].latitude) / 2,
            points[finalPointIndex].longitude +
                (points[0].longitude - points[finalPointIndex].longitude) / 2);

        final indexClosure = points.length - 1;

        dragMarkers.add(DragMarker(
          point: intermediatePoint,
          size: intermediateIconSize,
          builder: (_, __, ___) => intermediateIcon!,
          onDragStart: (details, point) {
            points.insert(indexClosure + 1, intermediatePoint);
            _markerToUpdate = indexClosure + 1;
          },
          onDragUpdate: updateMarker,
        ));
      }
    }

    return dragMarkers;
  }
}
