import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

class PolylinePage extends StatefulWidget {
  const PolylinePage({super.key});

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  late PolyEditor polyEditor;

  final polyPoints = <LatLng>[];

  @override
  void initState() {
    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: polyPoints,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: (LatLng? _) {
        //debugPrint("polyedit setstate");
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final polyLines = <Polyline>[];
    final testPolyline = Polyline(color: Colors.deepOrange, points: polyPoints);
    polyLines.add(testPolyline);

    return Scaffold(
      appBar: AppBar(title: const Text('Polyline example')),
      body: FlutterMap(
        options: MapOptions(
          onTap: (_, ll) {
            polyEditor.add(testPolyline.points, ll);
          },
          // For backwards compatibility with pre v5 don't use const
          // ignore: prefer_const_constructors
          initialCenter: LatLng(45.5231, -122.6765),
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(polylines: polyLines),
          DragMarkers(markers: polyEditor.edit()),
        ],
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
