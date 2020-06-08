# flutter_map_line_editor

A basic line/poly editor that works with flutter_map and dragmarkers.

Tap to add a marker, add several.

Drag the main points to move them.

Drag the intermediate points to create a new point there and drag.

Long press to delete a point.

Set up a new editor instance with

    polyEditor = new PolyEditor(
      points: testPolyline.points,
      pointIcon: Icon(Icons.crop_square, size: 23),
      intermediateIcon: Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: () => { this.setState(() {})},
    );


