import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {

  late PolyEditor polyEditor;

  List<Polygon> polygons = [];
  var testPolygon = new Polygon(
      color: Colors.deepOrange,
      points: []
  );

  @override
  void initState() {
    super.initState();

    polyEditor = new PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: Icon(Icons.crop_square, size: 23),
      intermediateIcon: Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => { this.setState(() {})},
    );
    
    polygons.add( testPolygon );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: FlutterMap(
              options: MapOptions(
                allowPanningOnScrollingParent: false,
                onTap: (_,ll) {
                  polyEditor.add(testPolygon.points, ll);
                },
                plugins: [
                  DragMarkerPlugin(),
                ],
                center: LatLng(45.5231, -122.6765),
                zoom: 6.4,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                PolygonLayerOptions(polygons: polygons),
                DragMarkerPluginOptions(markers: polyEditor.edit()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
