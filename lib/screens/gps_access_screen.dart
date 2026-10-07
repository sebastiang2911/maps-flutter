import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
          return !state.isGpsEnabled
              ? const _EnableGpsMessage()
              : const _AccessButton();
        }),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('This app need to work with GPS'),
        const SizedBox(height: 20),
        MaterialButton(
          elevation: 0,
          color: Colors.blue,
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          splashColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const Text('Request Access',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'You must enable the GPS to use this app.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
