import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late PolyEditor polyEditor;

  final polyLines = <Polyline>[];
  final testPolyline = Polyline(color: Colors.deepOrange, points: []);

  @override
  void initState() {
    super.initState();

    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: testPolyline.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: (_) {
        //debugPrint("polyedit setstate");
        setState(() {});
      },
    );

    polyLines.add(testPolyline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List example')),
      body: Center(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            if (index == 2) {
              return SizedBox(
                height: 200,
                child: Card(
                  child: FlutterMap(
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
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      PolylineLayer(polylines: polyLines),
                      DragMarkers(markers: polyEditor.edit()),
                    ],
                  ),
                ),
              );
            }
            return SizedBox(
              height: 100,
              child: Card(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("List Item $index"),
                ),
              ),
            );
          },
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
