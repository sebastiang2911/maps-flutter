import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => state.displayManualMarker
            ? const _ManualMarkerBody()
            : const SizedBox());
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(children: [
        //Btn back
        const Positioned(top: 70, left: 20, child: _BtnBack()),
        //Icon position in map
        Center(
          child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                  from: 100, child: const Icon(Icons.location_on, size: 50))),
        ),
        //Button confirm
        Positioned(bottom: 70, left: 40, child: _BtnConfirm(size: size)),
      ]),
    );
  }
}

class _BtnConfirm extends StatelessWidget {
  const _BtnConfirm({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(context);
    final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    final MapBloc mapBloc = BlocProvider.of<MapBloc>(context);

    GlobalKey _scaffold = GlobalKey();

    return FadeInUp(
      key: _scaffold,
      duration: const Duration(milliseconds: 300),
      child: MaterialButton(
        minWidth: size.width - 120,
        height: 50,
        shape: const StadiumBorder(),
        elevation: 0,
        color: Colors.black87,
        onPressed: () async {
          final start = locationBloc.state.lastKnowLocation;
          if (start == null) return;
          final end = mapBloc.mapCenter;
          if (end == null) return;

          showLoadingMessage(context);

          final destination = await searchBloc.getCoorStartToEnd(start, end);
          await mapBloc.drawRoutePolyline(destination);

          searchBloc.add(OnDisabledManualMarker());
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        child: const Text('Confirm destination',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack();

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () {
              BlocProvider.of<SearchBloc>(context).add(
                OnDisabledManualMarker(),
              );
            }),
      ),
    );
  }
}
