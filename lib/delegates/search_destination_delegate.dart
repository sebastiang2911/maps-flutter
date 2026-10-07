import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate()
      : super(
          searchFieldLabel: 'Buscar...',
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        final result = SearchResult(isCancel: true);
        close(context, result);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnowLocation!;

    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      final places = state.places;
      return ListView.separated(
        itemCount: places.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final place = places[index];
          return ListTile(
            title: Text(place.text),
            subtitle: Text(place.placeName),
            leading: const Icon(Icons.place, color: Colors.black),
            onTap: () {
              final result = SearchResult(
                isCancel: false,
                isManual: false,
                position: LatLng(place.center[1], place.center[0]),
                nameDestination: place.text,
                descriptionDestination: place.placeName,
              );
              searchBloc.addToHistory(place);
              close(context, result);
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          title: const Text('Colocar ubicación manualmente',
              style: TextStyle(
                color: Colors.black54,
              )),
          onTap: () {
            final result = SearchResult(isCancel: false, isManual: true);
            close(context, result);
          },
        ),
        ...history.map((e) => ListTile(
              leading: const Icon(Icons.history, color: Colors.black),
              title: Text(e.text),
              subtitle: Text(e.placeName),
              onTap: () {
                final result = SearchResult(
                  isCancel: false,
                  isManual: false,
                  position: LatLng(e.center[1], e.center[0]),
                  nameDestination: e.text,
                  descriptionDestination: e.placeName,
                );
                close(context, result);
              },
            )),
      ],
    );
  }
}
