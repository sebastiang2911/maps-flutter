part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarker extends SearchEvent {}

class OnDisabledManualMarker extends SearchEvent {}

class OnNewPlacesEvent extends SearchEvent {
  final List<Feature> places;

  const OnNewPlacesEvent(this.places);
}

class AddToHistoryEvent extends SearchEvent {
  final Feature result;
  const AddToHistoryEvent(this.result);
}
