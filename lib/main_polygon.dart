import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'polyeditor.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  PolyEditor polyEditor;

  List<Polyline> polyLines = [];
  static const d = 1;
  var testPolyline = new Polyline(color: Colors.deepOrange, points: [
    LatLng(45.5231 - d, -122.676 - d),
    LatLng(45.5231 + d, -122.676 - d),
    LatLng(45.5231 + d, -122.676 + d),
    LatLng(45.5231 - d, -122.676 + d),
    LatLng(45.5231 - d, -122.676 - d),
  ]);

  @override
  void initState() {
    super.initState();

    polyEditor = new PolyEditor(
      addClosePathMarker: true,
      points: testPolyline.points,
      pointIcon: Icon(Icons.crop_square, size: 23),
      intermediateIcon: Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => {this.setState(() {})},
    );

    polyLines.add(testPolyline);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: FlutterMap(
              options: MapOptions(
                onTap: (ll) {
                  polyEditor.add(testPolyline.points, ll);
                },
                plugins: [
                  DragMarkerPlugin(),
                ],
                center: LatLng(45.5231, -122.6765),
                zoom: 6.4,
              ),
              layers: [
                // TileLayerOptions(
                //     urlTemplate:
                //         'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                //     subdomains: ['a', 'b', 'c']),
                PolylineLayerOptions(polylines: polyLines),
                DragMarkerPluginOptions(markers: polyEditor.edit()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
