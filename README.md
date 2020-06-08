# flutter_map_line_editor

A basic line/poly editor that works with flutter_map and dragmarkers.

See main.dart for example, but here are the basic features:

Tap the map to add a marker, add as many as you want.

Drag the main points to move them.

Drag the intermediate points to create a new point there and drag to where you want.

Long press to delete a point.

Set up a new editor instance with

    polyEditor = new PolyEditor(
      points: testPolyline.points,
      pointIcon: Icon(Icons.crop_square, size: 23),
      intermediateIcon: Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => { this.setState(() {})},
    );
    
You can add a point programmatically from a tap, in the mapoptions...eg
```
   onTap: (ll) {
     polyEditor.add(testPolyline.points, ll);
   },
 ```               
https://user-images.githubusercontent.com/3901173/84055684-18e02300-a9ad-11ea-8ee6-cbcfbf361391.gif

