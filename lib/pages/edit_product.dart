import 'package:flutter/material.dart';
import 'package:shoppingonline/models/product.dart';

import '../universes/Constant.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;

  const EditProduct({super.key, required this.productModel});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    print('## name Edit ==>> ${productModel!.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: MyConstant.primary,
      ),
    );
  }
}