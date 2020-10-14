library polyeditor;

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';

class PolyEditor {
  final List points;
  final Widget pointIcon;
  final Size pointIconSize;
  final Widget intermediateIcon;
  final Size intermediateIconSize;
  final Function callbackRefresh;
  final bool addClosePathMarker;

  PolyEditor({
    this.points,
    this.pointIcon,
    this.intermediateIcon,
    this.callbackRefresh,
    this.addClosePathMarker,
    this.pointIconSize = const Size(30, 30),
    this.intermediateIconSize = const Size(30, 30),
  });

  int markerToUpdate;

  void updateMarker(details,point) {
    this.points[markerToUpdate] = new LatLng(point.latitude, point.longitude);
    this.callbackRefresh();
  }

  List add(List<LatLng> pointsList, point) {
    pointsList.add( point );
    this.callbackRefresh();
    return pointsList;
  }

  LatLng remove(int index) {
    return this.points.removeAt(index);
  }

  List<DragMarker> edit() {
    List<DragMarker> dragMarkers = [];

    for (var c=0; c<this.points.length; c++) {
      var indexClosure = c;
      dragMarkers.add(
          DragMarker(
            point: this.points[indexClosure],
            width: pointIconSize.width,
            height: pointIconSize.height,
            builder: (ctx) =>
                Container(
                    child: this.pointIcon
                ),
            onDragStart: (_,__) { markerToUpdate = indexClosure; },
            onDragUpdate: updateMarker,
            onLongPress: (ll) {
              this.remove(indexClosure);
              this.callbackRefresh();
            }
          )
      );
    }

    for (var c=0; c<this.points.length - 1; c++) {
      var polyPoint = this.points[c];
      var polyPoint2 = this.points[c+1];

      var indexClosure = c;
      var intermediatePoint = new LatLng(polyPoint.latitude +
          (polyPoint2.latitude - polyPoint.latitude) / 2 ,
          polyPoint.longitude + (polyPoint2.longitude - polyPoint.longitude) / 2);

      dragMarkers.add(
          DragMarker(
            point: intermediatePoint,
            width: intermediateIconSize.width,
            height: intermediateIconSize.height,
            builder: (ctx) =>
                Container(
                    child: this.intermediateIcon
                ),
            onDragStart: (details, point) {
              this.points.insert(indexClosure + 1, intermediatePoint);
              markerToUpdate = indexClosure + 1;
            },
            onDragUpdate: updateMarker,
          )
      );
    }

    /// Final close marker from end back to beginning we want if its a closed polygon.
    if(addClosePathMarker && (this.points.length > 2)) {
      var finalPointIndex = this.points.length - 1;

      var intermediatePoint = new LatLng(this.points[finalPointIndex].latitude +
          (this.points[0].latitude - this.points[finalPointIndex].latitude) / 2 ,
          this.points[finalPointIndex].longitude + (this.points[0].longitude - this.points[finalPointIndex].longitude) / 2);

      var indexClosure = this.points.length - 1;

      dragMarkers.add(
          DragMarker(
            point: intermediatePoint,
            width: intermediateIconSize.width,
            height: intermediateIconSize.height,
            builder: (ctx) =>
                Container(
                    child: this.intermediateIcon
                ),
            onDragStart: (details, point) {
              this.points.insert(indexClosure + 1, intermediatePoint);
              markerToUpdate = indexClosure + 1;
            },
            onDragUpdate: updateMarker,
          )
      );
    }

    return dragMarkers;
  }

}

