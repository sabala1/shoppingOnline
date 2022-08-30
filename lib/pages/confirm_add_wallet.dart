import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/utillity/dialog.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../utillity/constant.dart';

class ConfirmAddWallet extends StatefulWidget {
  const ConfirmAddWallet({super.key});

  @override
  State<ConfirmAddWallet> createState() => _ConfirmAddWalletState();
}

class _ConfirmAddWalletState extends State<ConfirmAddWallet> {
  late String dateTimeStr;
  File? _image;
  var formKey = GlobalKey<FormState>();

  String? idBuyer;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    findIdBuyer();
  }

  
  Future<void> findIdBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yy HH:mm');
    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
    print('dateTime ==>> $dateTimeStr');
  }

  Future<Null> createImage({ImageSource? source}) async {
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

Future<void> processUploadAndInsertData() async {
    // upload Image to Server
    String apiSaveSlip = '${MyConstant.domain}/shoppingmall/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    MyDialog().showProcressDialog(context);

    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(_image!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveSlip, data: data).then((value) async {
        print('value ==>> $value');
        Navigator.pop(context);

        // insert value to mySQL
        var pathSlip = '/slip/$nameSlip';
        var status = 'WaitOrder';
        var urlAPIinsert =
            '${MyConstant.domain}/shoppingonline/insertWallet.php?isAdd=true&idBuyer=$idBuyer&datePay=$dateTimeStr&money=${moneyController.text.trim()}&pathSlip=$pathSlip&status=$status';
        await Dio().get(urlAPIinsert).then(
              (value) => MyDialog(funcAction: success).actionDialog(
                context,
                'Confirm Success',
                'Comfirm Add Money to Wallet Success',
              ),
            );
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: const Text('Confirm Add Wallet'),
        leading: IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeBuyerService),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShowTitle(
                title: 'Current Date Pay',
                textStyle: MyConstant().p1Style(),
              ),
            ),
          ),
          ShowTitle(
            title: dateTimeStr == null ? 'dd/MM/yy HH:mm' : dateTimeStr,
            textStyle: MyConstant().b2NorStyle(),
          ),
          newMoney(),
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => createImage(source: ImageSource.camera),
                  icon: Icon(Icons.add_a_photo),
                ),
                Container(
                  width: size * 0.6,
                  child: _image == null
                      ? ShowImage(pathImage: 'images/bill.png')
                      : Image.file(_image!),
                ),
                IconButton(
                  onPressed: () => createImage(source: ImageSource.gallery),
                  icon: Icon(Icons.add_photo_alternate),
                ),
              ],
            ),
          ),
          buildElevatedButton()
        ],
      ),
    );
  }

  Row newMoney() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: TextFormField(
            controller: moneyController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Money',
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

  void success() {
    Navigator.pushNamedAndRemoveUntil(
        context, MyConstant.routeBuyerService, (route) => false);
    print('Success Work');
  }

  Row buildElevatedButton() {
    double size = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 45,
          child: ElevatedButton(
            style: MyConstant().bg1Style(),
            onPressed: () {
              if(_image == null) {
                MyDialog().normalDialog(context, 'กรุณาถ่ายภาพหรือเลือกรูปภาพที่คุณมี', '');
              }else {
                processUploadAndInsertData();
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
