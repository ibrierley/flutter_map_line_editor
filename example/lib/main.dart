import 'package:example/list_page.dart';
import 'package:example/map_in_map_page.dart';
import 'package:example/polygon_page.dart';
import 'package:example/polyline_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            PolylinePage(),
            PolygonPage(),
            ListPage(),
            MapInMapPage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.linear_scale_rounded),
              label: 'Polyline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Polygon',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.zoom_in),
              label: 'Map in Map',
            ),
          ],
        ),
      ),
    );
  }
}
