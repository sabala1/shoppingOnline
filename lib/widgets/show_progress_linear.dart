import 'package:flutter/material.dart';

import '../utillity/constant.dart';

class ShowProgressLinear extends StatelessWidget {
  const ShowProgressLinear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: LinearProgressIndicator(
            color: MyConstant.bluelight,
          ),
        ),
      ),
    );
  }
}
