import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_progress_linear.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../utillity/constant.dart';
import '../utillity/dialog.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  String avatar = '';
  bool statusRedEye = true;
  File? _image;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'Allow Shar Location', 'Don\'t Shar Location');
        } else {
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'Allow Shar Location', 'Don\'t Shar Location');
        } else {
          findLatLng();
        }
      }
    } else {
      print('Service Location close');
      MyDialog().alertLocationService(
          context, 'Turn on Location?', 'Pleases Turn on Your Location');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng ==> Work!!');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Set<Marker> setMarker() => <Marker>{
    Marker(
      markerId: const MarkerId('id'),
      position: LatLng(lat!, lng!),
      infoWindow:
          InfoWindow(title: 'You Here', snippet: 'Lat = $lat, lng = $lng'),
    ),
  };

  Widget buildMap() => SizedBox(
        width: double.infinity,
        height: 250,
        child: lat == null
            ? const ShowProgressLinear()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ),
      );

  Future<Null> processImagePicker(ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(
        source: source,
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
          buildCheckTypeUser(),
        ],
        title: const Text('Create New Account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle('ข้อมูลทั่วไป :'),
                  buildName(size),
                  buildTitle('คุณคือ :'),
                  buildRadioBuyer(),
                  buildRadioSeller(),
                  buildRadioRider(),
                  buildTitle('ข้อมูลพื้นฐาน :'),
                  buildNewAddress(size),
                  buildPhone(size),
                  buildUser(size),
                  buildPassword(size),
                  buildTitle('รูปภาพ: '),
                  buildSubTitle(),
                  buildAvatar(size),
                  buildTitle('พิกัดของคุณ :'),
                  buildMap(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildCheckTypeUser() {
    return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (typeUser == null) {
            print('Non Choose Type User');
            MyDialog().normalDialog(
                context, 'Choose TypeUser', 'Please Tap Choose TypeUser');
          } else {
            print('Process Insert to Database');
            uploadPicAndInsertData();
          }
        }
      },
      icon: const Icon(Icons.cloud_upload),
    );
  }

  Future<Null> uploadPicAndInsertData() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;
    print(
        '## name = $name, address = $address, phone = $phone, user = $user, password = $password');
    String path =
        '${MyConstant.domain}/shoppingonline/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(path).then(
      (value) async {
        print('## value ==>> $value');
        if (value.toString() == 'null') {
          print('## user OK');
          if (_image == null) {
            //No Avatar
            processInsertMySQL(name: name, address: address, phone: phone, user: user, password: password);
          } else {
            //Have Avatar
            String apiSaveAvatar =
                '${MyConstant.domain}/shoppingonline/saveAvatar.php';
            int i = Random().nextInt(100000000);
            String nameImageAvatar = 'avatar$i.jpg';
            Map<String, dynamic> map = Map();
            map['file'] = await MultipartFile.fromFile(_image!.path,
                filename: nameImageAvatar);
            FormData data = FormData.fromMap(map);
            await Dio().post(apiSaveAvatar, data: data).then((value) {
              avatar = '/shoppingonline/avatar/$nameImageAvatar';
              processInsertMySQL(name: name, address: address, phone: phone, user: user, password: password);
            });
          }
        } else {
          MyDialog().normalDialog(context, 'User Ready', 'Pleass Change User');
        }
      },
    );
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? address,
      String? phone,
      String? user,
      String? password}) async {
    print('## processInsertMySQL Work & avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/shoppingonline/insertUser.php?isAdd=true&name=$name&type=$typeUser&address=$address&phone=$phone&user=$user&password=$password&avatar=$avatar&lat=$lat&lng=$lng';
    
    await Dio().get(apiInsertUser).then(
      (value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'Create New User False!!', 'Please Try Again');
      }
    });
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: size * 0.75,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Name :',
              prefixIcon: Icon(
                Icons.account_circle,
                color: MyConstant.pinkdark,
              ),
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

  Row buildNewAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: size * 0.75,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a valod address.';
              } else {}
            },
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Address :',
              hintStyle: MyConstant().p3Style(),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 45),
                child: Icon(
                  Icons.home,
                  color: MyConstant.pinkdark,
                ),
              ),
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

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: size * 0.75,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter avalid Phone number.';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Phone number:',
              prefixIcon: Icon(
                Icons.phone,
                color: MyConstant.pinkdark,
              ),
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

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: size * 0.75,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'User :',
              prefixIcon: Icon(
                Icons.account_circle_outlined,
                color: MyConstant.pinkdark,
              ),
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

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: size * 0.75,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {}
            },
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: MyConstant.pinkdark,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyConstant.pinkdark,
                      ),
              ),
              labelStyle: MyConstant().p3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyConstant.pinkdark,
              ),
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

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => processImagePicker(ImageSource.camera),
          icon: const Icon(
            Icons.add_a_photo,
            size: 36,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: _image == null
              ? ShowImage(pathImage: MyConstant.avatar)
              : Image.file(_image!),
        ),
        IconButton(
          onPressed: () => processImagePicker(ImageSource.gallery),
          icon: const Icon(
            Icons.add_photo_alternate,
            size: 36,
          ),
        ),
      ],
    );
  }

  ShowTitle buildSubTitle() {
    return ShowTitle(
      title: 'รูปภาพแสดงตัวตน   *ไม่บังคับ',
      textStyle: MyConstant().p3Style(),
    );
  }

  RadioListTile<String> buildRadioBuyer() {
    return RadioListTile(
      value: 'buyer',
      groupValue: typeUser,
      onChanged: (value) {
        setState(() {
          typeUser = value;
        });
      },
      title: ShowTitle(
        title: 'ผู้ซื้อ (Buyer)',
        textStyle: MyConstant().p3Style(),
      ),
    );
  }

  RadioListTile<String> buildRadioSeller() {
    return RadioListTile(
      value: 'seller',
      groupValue: typeUser,
      onChanged: (value) {
        setState(() {
          typeUser = value;
        });
      },
      title: ShowTitle(
        title: 'ผู้ขาย (Seller)',
        textStyle: MyConstant().p3Style(),
      ),
    );
  }

  RadioListTile<String> buildRadioRider() {
    return RadioListTile(
      value: 'rider',
      groupValue: typeUser,
      onChanged: (value) {
        setState(() {
          typeUser = value;
        });
      },
      title: ShowTitle(
        title: 'ผู้ส่ง (Rider)',
        textStyle: MyConstant().p3Style(),
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
}
