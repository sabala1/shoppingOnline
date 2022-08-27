import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingonline/utillity/constant.dart';
import 'package:shoppingonline/widgets/show_progress_circular.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../../models/user.dart';

class ShowManageSeller extends StatefulWidget {
  final UserModel userModel;
  const ShowManageSeller({super.key, required this.userModel});

  @override
  State<ShowManageSeller> createState() => _ShowManageSellerState();
}

class _ShowManageSellerState extends State<ShowManageSeller> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  Future<Null> refresUserModel() async {
    print('## resfressUserModel Work!!');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingonline/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: MyConstant.pinkdark,
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeEditProfileSeller).then(
            (value) => refresUserModel(),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  ShowTitle(
                    title: 'Name Shop : ',
                    textStyle: MyConstant().b2NorStyle(),
                  ),
                  ShowTitle(
                    title: userModel!.name,
                    textStyle: MyConstant().g2Style(),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              Wrap(
                children: [
                  ShowTitle(
                    title: 'Address : ',
                    textStyle: MyConstant().b2NorStyle(),
                  ),
                  ShowTitle(
                    title: userModel!.address,
                    textStyle: MyConstant().g2Style(),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              Wrap(
                children: [
                  ShowTitle(
                    title: 'Phone : ',
                    textStyle: MyConstant().b2NorStyle(),
                  ),
                  ShowTitle(
                    title: userModel!.phone,
                    textStyle: MyConstant().g2Style(),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              ShowTitle(
                title: 'Avatar : ',
                textStyle: MyConstant().b2NorStyle(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: size * 0.6,
                    child: CachedNetworkImage(
                      imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                      placeholder: (context, url) =>
                          const ShowProgressCircular(),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              ShowTitle(
                title: 'Location : ',
                textStyle: MyConstant().b2NorStyle(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: size * 0.8,
                    height: size * 0.8,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        zoom: 16,
                        target: LatLng(
                          double.parse(userModel!.lat),
                          double.parse(userModel!.lng),
                        ),
                      ),
                      markers: setMarker.toSet(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Marker> get setMarker {
    return <Marker>[
      Marker(
          markerId: const MarkerId('id'),
          position: LatLng(
            double.parse(userModel!.lat),
            double.parse(userModel!.lng),
          ),
          infoWindow: InfoWindow(
              title: 'You Here ',
              snippet: 'lat = ${userModel!.lat}, lng = ${userModel!.lng}')),
    ];
  }
}
