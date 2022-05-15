library polyeditor;

import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';

class PolyEditor {
  final List points;
  final Widget pointIcon;
  final Size pointIconSize;
  final Widget? intermediateIcon;
  final Size intermediateIconSize;
  final Function? callbackRefresh;
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

  int? markerToUpdate;

  void updateMarker(details, point) {
    if (markerToUpdate != null) {
      points[markerToUpdate!] = LatLng(point.latitude, point.longitude);
    }
    callbackRefresh?.call();
  }

  List add(List<LatLng> pointsList, point) {
    pointsList.add(point);
    callbackRefresh?.call();
    return pointsList;
  }

  LatLng remove(int index) {
    return points.removeAt(index);
  }

  List<DragMarker> edit() {
    List<DragMarker> dragMarkers = [];

    for (var c = 0; c < points.length; c++) {
      var indexClosure = c;
      dragMarkers.add(DragMarker(
          point: points[indexClosure],
          width: pointIconSize.width,
          height: pointIconSize.height,
          builder: (ctx) => Container(child: pointIcon),
          onDragStart: (_, __) {
            markerToUpdate = indexClosure;
          },
          onDragUpdate: updateMarker,
          onLongPress: (ll) {
            remove(indexClosure);
            callbackRefresh?.call();
          }));
    }

    for (var c = 0; c < points.length - 1; c++) {
      var polyPoint = points[c];
      var polyPoint2 = points[c + 1];

      var indexClosure = c;
      var intermediatePoint = LatLng(
          polyPoint.latitude + (polyPoint2.latitude - polyPoint.latitude) / 2,
          polyPoint.longitude +
              (polyPoint2.longitude - polyPoint.longitude) / 2);

      dragMarkers.add(DragMarker(
        point: intermediatePoint,
        width: intermediateIconSize.width,
        height: intermediateIconSize.height,
        builder: (ctx) => Container(child: intermediateIcon),
        onDragStart: (details, point) {
          points.insert(indexClosure + 1, intermediatePoint);
          markerToUpdate = indexClosure + 1;
        },
        onDragUpdate: updateMarker,
      ));
    }

    /// Final close marker from end back to beginning we want if its a closed polygon.
    if (addClosePathMarker && (points.length > 2)) {
      var finalPointIndex = points.length - 1;

      var intermediatePoint = LatLng(
          points[finalPointIndex].latitude +
              (points[0].latitude - points[finalPointIndex].latitude) / 2,
          points[finalPointIndex].longitude +
              (points[0].longitude - points[finalPointIndex].longitude) / 2);

      var indexClosure = points.length - 1;

      dragMarkers.add(DragMarker(
        point: intermediatePoint,
        width: intermediateIconSize.width,
        height: intermediateIconSize.height,
        builder: (ctx) => Container(child: intermediateIcon),
        onDragStart: (details, point) {
          points.insert(indexClosure + 1, intermediatePoint);
          markerToUpdate = indexClosure + 1;
        },
        onDragUpdate: updateMarker,
      ));
    }

    return dragMarkers;
  }
}
