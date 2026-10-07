import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationBloc() : super(const LocationState()) {
    on<OnFollowingUser>((event, emit) {
      emit(state.copyWith(followingUser: true));
    });
    on<OnStopFollowingUser>((event, emit) {
      emit(state.copyWith(followingUser: false));
    });

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnowLocation: event.location,
        myLocationHistory: [...state.myLocationHistory, event.location],
      ));
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() async {
    add(OnFollowingUser());
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void stopFollowingUser() {
    _positionStreamSubscription?.cancel();
    add(OnStopFollowingUser());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
