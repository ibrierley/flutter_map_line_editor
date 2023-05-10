import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_line_editor/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:latlong2/latlong.dart';

class PolygonPage extends StatefulWidget {
  const PolygonPage({Key? key}) : super(key: key);

  @override
  State<PolygonPage> createState() => _PolygonPageState();
}

class _PolygonPageState extends State<PolygonPage> {
  late PolyEditor polyEditor;

  List<Polygon> polygons = [];
  var testPolygon =
      Polygon(color: Colors.deepOrange, isFilled: true, points: []);

  @override
  void initState() {
    super.initState();

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => {setState(() {})},
    );

    polygons.add(testPolygon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polygon example')),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            onTap: (_, ll) {
              polyEditor.add(testPolygon.points, ll);
            },
            center: LatLng(45.5231, -122.6765),
            zoom: 6.4,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            PolygonLayer(polygons: polygons),
            DragMarkers(markers: polyEditor.edit()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () {
          setState(() {
            testPolygon.points.clear();
          });
        },
      ),
    );
  }
}
