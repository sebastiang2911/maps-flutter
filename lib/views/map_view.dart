import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/blocs/blocs.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapView({
    required this.initialLocation,
    super.key,
    required this.polylines,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Listener(
        onPointerMove: (event) => mapBloc.add(OnStopFollowingUserMap()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) =>
              mapBloc.add(OnMapInitilizedEvent(controller)),
          polylines: polylines,
          onCameraMove: (position) => mapBloc.mapCenter = position.target,
          markers: markers,
        ),
      ),
    );
  }
}
