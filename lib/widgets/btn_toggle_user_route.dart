import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';

class BtnToogleUserRoute extends StatelessWidget {
  const BtnToogleUserRoute({super.key});

  @override
  Widget build(BuildContext context) {
    MapBloc mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                Icons.timeline,
                color: state.isShowMyRoute ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                mapBloc.add(OnToggleMyRoute());
              },
            );
          },
        ),
      ),
    );
  }
}
