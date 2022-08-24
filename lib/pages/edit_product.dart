import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingonline/models/product.dart';
import 'package:shoppingonline/universes/dialog.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../universes/Constant.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;

  const EditProduct({super.key, required this.productModel});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;
  TextEditingController pdnameController = TextEditingController();
  TextEditingController pdpriceController = TextEditingController();
  TextEditingController pddetailController = TextEditingController();

  List<String> pathImages = [];
  List<String> paths = [];
  List<File?> _image = [];
  bool statusImage = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    pdnameController.text = productModel!.name;
    pdpriceController.text = productModel!.price;
    pddetailController.text = productModel!.detail;
    converStringToArray();
  }

  void converStringToArray() {
    String string = productModel!.images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      _image.add(null);
    }
    print('## pathImage ==>> ${pathImages}');
  }

  Future<Null> processImagePicker(int index, ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        _image[index] = File(image!.path);
        statusImage = true;
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
          backgroundColor: MyConstant.primary,
          title: Text('Add Product'),
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
                      buildEditNameProduct(size),
                      buildEditPricProduct(size),
                      buildEditProductDetail(size),
                      buildTitle('Image Product : '),
                      buildImage(size, 0),
                      buildImage(size, 1),
                      buildImage(size, 2),
                      buildImage(size, 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container buildImage(double size, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => processImagePicker(index, ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo,
              size: 36,
            ),
          ),
          Container(
            width: size * 0.6,
            child: _image[index] == null
                ? CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        '${MyConstant.domain}/shoppingonline/${pathImages[index]}')
                : Image.file(_image[index]!),
          ),
          IconButton(
            onPressed: () => processImagePicker(index, ImageSource.gallery),
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

  Row buildEditProductDetail(double size) {
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

  Row buildEditPricProduct(double size) {
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

  Row buildEditNameProduct(double size) {
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

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProcressDialog(context);

      String name = pdnameController.text;
      String price = pdpriceController.text;
      String detail = pddetailController.text;
      String id = productModel!.id;
      String images;
      if (statusImage) {
        //upload Image and Refresh array pathImages
        int index = 0;
        for (var item in _image) {
          if (item != null) {
            int i = Random().nextInt(100000000);
            String nameImage = 'product$i.jpg';
            String apiUploadImage =
                '${MyConstant.domain}/shoppingonline/saveProduct.php';

            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData data = FormData.fromMap(map);
            await Dio().post(apiUploadImage, data: data).then(
              (value) {
                pathImages[index] = '/product/$nameImage';
              },
            );
          }
          index++;
        }

        images = pathImages.toString();
        Navigator.pop(context);
      } else {
        images = pathImages.toString();
        Navigator.pop(context);
      }
      print('## statusImage = $statusImage');
      print('## id = $id, name = $name, price = $price, detail = $detail');
      print('## image = $images');

      String apiEditProduct =
          '${MyConstant.domain}/shoppingonline/editProductWhereId.php?isAdd=true&id=$id&name=$name&price=$price&detail=$detail&images=$images';
      await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    }
  }
}
