import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/views/map_view.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);

  @override
  void initState() {
    super.initState();
    // locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    super.dispose();
    locationBloc.stopFollowingUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            if (locationState.lastKnowLocation == null) {
              return const Center(
                child: Text('Please wait...'),
              );
            }
            return BlocBuilder<MapBloc, MapState>(
              builder: (context, stateMap) {
                Map<String, Polyline> polylines = Map.from(stateMap.polylines);
                if (!stateMap.isShowMyRoute) {
                  polylines.removeWhere(((key, value) => key == 'myRoute'));
                }

                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      MapView(
                        initialLocation: locationState.lastKnowLocation!,
                        polylines: polylines.values.toSet(),
                        markers: stateMap.markers.values.toSet(),
                      ),
                      const SearchBar(),
                      const ManualMarker(),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            BtnToogleUserRoute(),
            BtnFollowUser(),
            BtnCurrentLocation(),
          ],
        ));
  }
}
