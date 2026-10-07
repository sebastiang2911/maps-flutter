import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(
          const GpsState(isGpsEnabled: false, isGpsPermissionGranted: false),
        ) {
    on<GpsAndPermissionEvent>((event, emit) => emit(
          state.copyWith(
            isGpsEnabled: event.isGpsEnabled,
            isGpsPermissionGranted: event.isPermissionGranted,
          ),
        ));
    _init();
  }

  Future<void> _init() async {
    // final isEnable = await _checkGpsStatus();
    // final isGranted = await _isPermissionGrante();
    final gpsInitStaus =
        await Future.wait([_checkGpsStatus(), _isPermissionGrante()]);

    add(GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStaus[0],
      isPermissionGranted: gpsInitStaus[1],
    ));
  }

  Future<bool> _isPermissionGrante() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
        isGpsEnabled: isEnabled,
        isPermissionGranted: state.isGpsPermissionGranted,
      ));
    });
    return isEnable;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isPermissionGranted: true,
        ));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isPermissionGranted: false,
        ));
        openAppSettings();
        break;
    }
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
