import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/universes/dialog.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../universes/Constant.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? _image;
  TextEditingController pdnameController = TextEditingController();
  TextEditingController pdpriceController = TextEditingController();
  TextEditingController pddetailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              buildCheckProduct();
            },
            icon: Icon(Icons.cloud_upload),
          ),
        ],
        backgroundColor: MyConstant.primary,
        title: Text('Add Product'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                buildProductName(size),
                buildProductPrice(size),
                buildProductDetail(size),
                buildImage(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var image = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        _image = File(image!.path);
        files[index] = _image;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click From index ==>> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowTitle(
                title: 'Source Image ${index + 1} ?',
                textStyle: MyConstant().b2Style(),
              ),
            ],
          ),
          subtitle: ShowTitle(
            title: 'Please Tab on Camera or Galler',
            textStyle: MyConstant().b3Style(),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> buildCheckProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var _image in files) {
        if (_image == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        print('## choose 4 image success');
        MyDialog().showProcressDialog(context);
        String apiSaveProduct = '${MyConstant.domain}/shoppingonline/saveProduct.php';
        print('## apiSaveProduct ==>> $apiSaveProduct');

        int loop = 0;
        for (var _image in files) {
          int i = Random().nextInt(100000000);
          String nameProduct = 'product$i.jpg';
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(_image!.path, filename: nameProduct);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data: data).then((value) async {
            print('Upload Success');
            loop ++;
            if(loop >= files.length) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              String? idSeller = preferences.getString('id');
              String? nameSeller = preferences.getString('name');
              String? name = pdnameController.text;
              String? price = pdpriceController.text;
              String? detail = pddetailController.text;
              print('## idSeller = $idSeller, nameSeller = $nameSeller');
              print('## name = $name, price = $price, detail = $detail');
              Navigator.pop(context);
            }
          },);
        }
      }
    } else {
      MyDialog()
          .normalDialog(context, 'More Image', 'Please Choose More Image');
    }
  }

  Column buildImage(double size) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Container(
            width: size * 0.75,
            height: size * 0.75,
            child: _image == null
                ? Image.asset(MyConstant.avatar1)
                : Image.file(_image!),
          ),
        ),
        Container(
          width: size * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.avatar1)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.avatar1)
                      : Image.file(files[1]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.avatar1)
                      : Image.file(files[2]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.avatar1)
                      : Image.file(files[3]!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildProductName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: size * 0.8,
          child: TextFormField(
            controller: pdnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Name Product : ',
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

  Row buildProductPrice(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: size * 0.8,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: pdpriceController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Price Product :',
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

  Row buildProductDetail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: size * 0.8,
          child: TextFormField(
            maxLines: 4,
            controller: pddetailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required.';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().p3Style(),
              labelText: 'Product Detail : ',
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
