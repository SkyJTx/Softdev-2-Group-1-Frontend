import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:ruam_mitt/Restroom/Component/cardpin.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ruam_mitt/global_const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
class MapRestroomRover extends StatelessWidget {
  const MapRestroomRover(
      {super.key,
      required this.restroomData,
      this.mapController,
      this.popupController,
      this.markers});

  final List<dynamic> restroomData;
  final List<Marker>? markers;
  final MapController? mapController;
  final PopupController? popupController;

// if (await Permission.location.ServiceStatus.isEnabled) {

// }

  @override
  Widget build(BuildContext context) {
    List<Marker> defaultMarkers = restroomData.map((restroom) {
      final String type = restroom["type"];
      return Marker(
        point: LatLng(
          restroom["latitude"].toDouble(),
          restroom["longitude"].toDouble(),
        ),
        width: 50,
        height: 50,
        rotate: true,
        child: type == "Must Paid"
            ? Image.asset(
                restroomPinImg[type]!,
              )
            : Image.asset(
                restroomPinImg[type]!,
                width: type == "Toilet In Stores" ? 50 : 50,
                height: type == "Toilet In Stores" ? 50 : 50,
                scale: type == "Toilet In Stores"
                    ? 5.0
                    : 5.15, // ปรับ scale สำหรับ "Free" ให้มีขนาดเท่ากับ "Toilet In Stores"
              ),
      );
    }).toList();

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialCenter: LatLng(13.825605, 100.514476),
            initialZoom: 15,
            minZoom: 10,
            maxZoom: 20,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            // PopupMarkerLayer(options: options)
            PopupMarkerLayer(
              options: PopupMarkerLayerOptions(
                popupController: popupController,
                markers: markers ?? defaultMarkers,
                popupDisplayOptions: PopupDisplayOptions(
                    animation: const PopupAnimation.fade(
                        duration: Duration(milliseconds: 150)),
                    builder: (BuildContext context, Marker marker) {
                      Map<String, dynamic> data = restroomData
                          .filter((restroom) =>
                              restroom["latitude"].toDouble() ==
                                  marker.point.latitude &&
                              restroom["longitude"].toDouble() ==
                                  marker.point.longitude)
                          .single;
                      return Cardpin(marker: marker, restroomData: data);
                    }),
              ),
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            CurrentLocationLayer(
              // followOnLocationUpdate: FollowOnLocationUpdate.always,
              // turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                markerSize: Size(40, 40),
                markerDirection: MarkerDirection.heading,
              ),
            ),
          ],
        ),
        Positioned(
            bottom: 20,
            right: 5,
            child: Image.asset(
              "assets/images/RestroomRover/type.png",
              width: 130,
              height: 130,
            )),
      ],
    );
  }
}
