import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:maps_app/services/services.dart';
import 'package:maps_app/models/models.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarker>((event, emit) {
      emit(state.copyWith(displayManualMarker: true));
    });
    on<OnDisabledManualMarker>((event, emit) {
      emit(state.copyWith(displayManualMarker: false));
    });
    on<OnNewPlacesEvent>((event, emit) {
      emit(state.copyWith(places: event.places));
    });
    on<AddToHistoryEvent>((event, emit) {
      emit(state.copyWith(history: [
        event.result,
        ...state.history,
      ]));
    });
  }

  Future<RouteDestination> getCoorStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    //Desination information

    final endPlace = await trafficService.getInfoByCoors(end);

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    //Decode geometry
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();
    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
      endPlace: endPlace,
    );
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
    add(OnNewPlacesEvent(newPlaces));
  }

  void addToHistory(Feature result) {
    add(AddToHistoryEvent(result));
  }
}
