import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/delegates/delegates.dart';

import 'package:maps_app/models/models.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : const _SearchBarBody();
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({super.key});

  void onSearchResults(BuildContext context, SearchResult result) async {
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(context);
    final MapBloc mapBloc = BlocProvider.of<MapBloc>(context);
    final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    if (result.isManual) searchBloc.add(OnActivateManualMarker());
    final start = locationBloc.state.lastKnowLocation;
    final end = result.position;
    if (start != null && end != null) {
      final destination = await searchBloc.getCoorStartToEnd(start, end);
      await mapBloc.drawRoutePolyline(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          // color: Colors.red,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: GestureDetector(
            onTap: () async {
              final result = await showSearch(
                  context: context, delegate: SearchDestinationDelegate());
              if (result == null) return;
              // ignore: use_build_context_synchronously
              onSearchResults(context, result);
            },
            child: FadeInDown(
              duration: const Duration(milliseconds: 300),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Search...',
                    style: TextStyle(color: Colors.black54),
                  )),
            ),
          )),
    );
  }
}
