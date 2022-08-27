import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_progress_circular.dart';

import '../models/user.dart';
import '../utillity/constant.dart';
import '../utillity/dialog.dart';
import '../widgets/show_title.dart';

class EditProfileSeller extends StatefulWidget {
  const EditProfileSeller({super.key});

  @override
  State<EditProfileSeller> createState() => _EditProfileSellerState();
}

class _EditProfileSellerState extends State<EditProfileSeller> {
  UserModel? userModels;
  final formKey = GlobalKey<FormState>();
  TextEditingController unameController = TextEditingController();
  TextEditingController uaddressController = TextEditingController();
  TextEditingController uphoneController = TextEditingController();
  LatLng? latLng;
  File? _image;

  @override
  void initState() {
    super.initState();
    findUser();
    findLatLng();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString('user');

    String apiGetUser =
        '${MyConstant.domain}/shoppingonline/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiGetUser).then((value) {
      print('## value from API ==>> $value');

      for (var item in json.decode(value.data)) {
        setState(() {
          userModels = UserModel.fromMap(item);
          unameController.text = userModels!.name;
          uaddressController.text = userModels!.address;
          uphoneController.text = userModels!.phone;
        });
      }
    });
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    if (position != null) {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
      });
    }
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProcressDialog(context);
      if (_image == null) {
        print('## User Current Avatar');
        editValueToMySQL(userModels!.avatar);
      } else {
        print('## User New Avatar');
        String apiSaveAvatar =
            '${MyConstant.domain}/shoppingonline/saveAvatar.php';

        List<String> nameAvatars = userModels!.avatar.split('/');
        String nameImage = nameAvatars[nameAvatars.length - 1];
        nameImage = 'edit ${Random().nextInt(100000000)}$nameImage';

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(_image!.path, filename: nameImage);
        FormData formData = FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then(
          (value) {
            print('Upload Succes');
            String pathAvatar = '/shoppingonline/avatar/$nameImage';
            editValueToMySQL(pathAvatar);
          },
        );

        print('## User New Avatar nameImage ==>> $nameImage');
      }
    }
  }

  Future<Null> editValueToMySQL(String pathAvatar) async {
    print('## pathAvatar ==>> $pathAvatar');
    String apiEditProfile =
        '${MyConstant.domain}/shoppingonline/editProfileSellerWhereId.php?isAdd=true&id=${userModels!.id}&name=${unameController.text}&address=${uaddressController.text}&phone=${uphoneController.text}&avatar=$pathAvatar&lat=${latLng!.latitude}&lng=${latLng!.longitude}';
    await Dio().get(apiEditProfile).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
  }

  Future<Null> createAvatar({ImageSource? source}) async {
    try {
      var image = await ImagePicker().pickImage(
        source: source!,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        _image = File(image!.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => processEdit(),
            icon: Icon(Icons.cloud_upload),
            tooltip: 'Edit Product',
          ),
        ],
        title: Text('Edit ProFile Seller'),
        backgroundColor: MyConstant.primary,
      ),
      body: LayoutBuilder(
        builder: (context, double) => SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(
              FocusScopeNode(),
            ),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle('General : '),
                    buildEditProfileName(size),
                    buildEditAddress(size),
                    buildEditPhone(size),
                    buildTitle('Avatar : '),
                    buildImage(size),
                    buildTitle('Location : '),
                    buildEditMap(size)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildEditMap(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: size * 0.8,
          height: size * 0.8,
          child: latLng == null
              ? ShowProgressCircular()
              : GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: latLng!, zoom: 16),
                  onMapCreated: ((controller) {}),
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId('id'),
                      position: latLng!,
                      infoWindow: InfoWindow(
                          title: 'Your Location',
                          snippet:
                              'lat = ${latLng!.latitude}, lng = ${latLng!.longitude}'),
                    ),
                  ].toSet(),
                ),
        ),
      ],
    );
  }

  Container buildImage(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => createAvatar(source: ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo,
              size: 36,
            ),
          ),
          Container(
            width: size * 0.6,
            child: userModels == null
                ? ShowProgressCircular()
                : userModels!.avatar == null
                    ? ShowImage(pathImage: userModels!.avatar)
                    : _image == null
                        ? CachedNetworkImage(
                            imageUrl:
                                '${MyConstant.domain}${userModels!.avatar}',
                          )
                        : Image.file(_image!),
          ),
          IconButton(
            onPressed: () => createAvatar(source: ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().p2Style(),
      ),
    );
  }

  Row buildEditProfileName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: size * 0.8,
          child: TextFormField(
            controller: unameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Name : ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.pinkdark),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.pinklight),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.errorvalidate),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.errorvalidate),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildEditAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: size * 0.8,
          child: TextFormField(
            maxLines: 4,
            controller: uaddressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Address : ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.pinkdark),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.pinklight),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.errorvalidate),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.errorvalidate),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildEditPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: size * 0.8,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: uphoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Phone : ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.pinkdark),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.pinklight),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.errorvalidate),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.errorvalidate),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
