import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';

class PolylinePage extends StatefulWidget {
  const PolylinePage({Key? key}) : super(key: key);

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  late PolyEditor polyEditor;

  List<Polyline> polyLines = [];
  var testPolyline = Polyline(color: Colors.deepOrange, points: []);

  @override
  void initState() {
    super.initState();

    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: testPolyline.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => {setState(() {})},
    );

    polyLines.add(testPolyline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polyline example')),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            allowPanningOnScrollingParent: false,
            onTap: (_, ll) {
              polyEditor.add(testPolyline.points, ll);
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
            PolylineLayerOptions(polylines: polyLines),
            DragMarkerPluginOptions(markers: polyEditor.edit()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () {
          setState(() {
            testPolyline.points.clear();
          });
        },
      ),
    );
  }
}
