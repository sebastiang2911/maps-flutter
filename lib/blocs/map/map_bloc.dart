import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/models/models.dart';

import 'package:maps_app/themes/uber.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({
    required this.locationBloc,
  }) : super(const MapState()) {
    on<OnMapInitilizedEvent>(_onInitMap);

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      if (!state.isFollowingUser) return;
      if (locationState.lastKnowLocation == null) return;
      moveCamera(locationState.lastKnowLocation!);
    });

    on<OnStopFollowingUserMap>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    on<OnStartFollowingUserMap>(_onStartFollowingUserMap);

    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleMyRoute>((event, emit) =>
        emit(state.copyWith(isShowMyRoute: !state.isShowMyRoute)));

    on<DisplayPolylinesEvent>((event, emit) => emit(state.copyWith(
          polylines: event.polylines,
          markers: event.markers,
        )));
  }

  void _onInitMap(OnMapInitilizedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUserMap(
      OnStartFollowingUserMap event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnowLocation == null) return;
    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      width: 5,
      color: Colors.black,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.points,
    );
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      width: 5,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100; //kms / 100;

    int tripDuration = (destination.duration / 60).floorToDouble().toInt();

    //CustomMarker

    // final startMaker = await getAssetImageMarker();
    final startMaker = await getStartCustomMarker(
      duration: tripDuration,
      location: 'My location',
    );
    // final endMaker = await getNetworkImageMarker();
    final endMaker = await getEndCustomMarker(
      kilometers: kms.toInt(),
      destination: destination.endPlace.placeName,
    );

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first, // destination.points[0],
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: 'Kms: $kms - Duration: $tripDuration',
      ),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      icon: startMaker,
      anchor: const Offset(0.1, 1),
    );
    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination
          .points.last, // destination.points[destination.points.length - 1],
      infoWindow: InfoWindow(
        title: destination.endPlace.text,
        snippet: destination.endPlace.placeName,
      ),
      // anchor: const Offset(0, 0),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      icon: endMaker,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;
    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;
    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

    await Future.delayed(
      const Duration(milliseconds: 800),
      () => {_mapController?.showMarkerInfoWindow(const MarkerId('end'))},
    );
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
