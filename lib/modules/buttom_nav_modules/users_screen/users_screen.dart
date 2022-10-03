import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UsersScreen extends StatelessWidget {
  static const String id = "UsersScreen";

  UsersScreen({Key? key}) : super(key: key);

  // final LatLng currentPostion;

  // void _getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance
  //       .getCurrentPosition(locationSettings:const LocationSettings(accuracy: LocationAccuracy.high,),);
  //
  //     // currentPostion = LatLng(position.latitude, position.longitude);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              body: Stack(alignment: Alignment.bottomCenter, children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(31.508235949598998, 31.84267226399344),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                SocialAppCubit.get(context).addToMarkers(Marker(
                  markerId: MarkerId("1"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet),
                  infoWindow: InfoWindow(
                      title: "${SocialAppCubit.get(context).usersModel?.name}",
                      snippet: "${SocialAppCubit.get(context).usersModel?.email}",
                      onTap: () {
                        // show users profile
                      }),
                  position: const LatLng(31.508235949598998, 31.84267226399344),
                ));
              },
              markers: SocialAppCubit.get(context).myMarkers,
            ),
            Padding(
                child: const Text("Displaying All Users Location.."),
                padding: EdgeInsets.only(bottom: 10)),
          ]));
        });
  }
}
