# flutter_map_line_editor

A basic line/poly editor that works with flutter_map and dragmarkers.

This relies on my plugin at https://github.com/ibrierley/flutter_map_dragmarker but this should get pulled in, if you add this git repo to your pubspec.yaml.

If you don't want to, you can just use the dragmarker.dart file in the above url, and then the polyeditor.dart file in this repo and import them locally at the top of your files.

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
      addClosePathMarker: false, // set to true if polygon
    );
 
point is a list of latlong points that are used for the polyline or whatever. It doesn't actually care it's a polyline, it could be something else, but it will put drag points over the top of the latlong points. The list will be edited in place, as it's just a reference as such. So flutter calls build each time, it will use the updated points. 
pointIcon is the icon to use for your main points to drag.
intermediateIcon is halfway between the main points. If you drag this icon, it will separate the line its on, into 2 new lines and attach draggable icons to it again.
callbackRefresh, the screen needs to be updated during a drag, so this will get called each drag frame.
    
Added: addClosePathMarker: true/false, if you have a closed path/polygon where the end auto returns to the start, set this to true, otherwise set to false (eg most polylines).

You can add a point programmatically from a tap, in the mapoptions...eg
```
   onTap: (ll) {
     polyEditor.add(testPolyline.points, ll);
   },
 ```     

![Demo](https://user-images.githubusercontent.com/3901173/84055684-18e02300-a9ad-11ea-8ee6-cbcfbf361391.gif)

Pull requests welcome!
