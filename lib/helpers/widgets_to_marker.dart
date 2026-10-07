import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;
import 'package:maps_app/markers/markers.dart';

Future<BitmapDescriptor> getStartCustomMarker({
  required int duration,
  required String location,
}) async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(350, 150);

  final startMarker = StartMarkerPainter(location: location, minutes: duration);
  startMarker.paint(canvas, size);

  final picture = recoder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getEndCustomMarker({
  required int kilometers,
  required String destination,
}) async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(350, 150);

  final startMarker =
      EndMarkerPainter(location: destination, kilometers: kilometers);
  startMarker.paint(canvas, size);

  final picture = recoder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byData!.buffer.asUint8List());
}
