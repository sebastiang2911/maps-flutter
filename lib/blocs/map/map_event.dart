part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitilizedEvent extends MapEvent {
  final GoogleMapController controller;

  const OnMapInitilizedEvent(this.controller);

  @override
  List<Object> get props => [controller];
}

class OnStopFollowingUserMap extends MapEvent {}

class OnStartFollowingUserMap extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> points;

  const UpdateUserPolylineEvent(this.points);
}

class OnToggleMyRoute extends MapEvent {}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const DisplayPolylinesEvent(this.polylines, this.markers);
}
