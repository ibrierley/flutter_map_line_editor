library polyeditor;

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
<<<<<<< HEAD
import 'package:flutter_map_dragmarker/dragmarker.dart';
=======
import 'dragmarker.dart';
>>>>>>> 1b9adbd56d400d7b7cdcdbc281614166f7ce41d6

class PolyEditor {
  final List points;
  final Icon pointIcon;
  final Icon intermediateIcon;
  final Function callbackRefresh;

  PolyEditor({
    this.points,
    this.pointIcon,
    this.intermediateIcon,
    this.callbackRefresh,
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
            width: 40.0,
            height: 40.0,
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
            width: 30.0,
            height: 30.0,
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

