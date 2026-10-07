import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {
  final bool isCancel;
  final bool isManual;
  final LatLng? position;
  final String? nameDestination;
  final String? descriptionDestination;

  SearchResult({
    required this.isCancel,
    this.isManual = false,
    this.position,
    this.nameDestination,
    this.descriptionDestination,
  });

  @override
  String toString() {
    return '{isCancel: $isCancel, isManual: $isManual}';
  }
}
