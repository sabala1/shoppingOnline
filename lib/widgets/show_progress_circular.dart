import 'package:flutter/material.dart';

import '../utillity/constant.dart';

class ShowProgressCircular extends StatelessWidget {
  const ShowProgressCircular ({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: CircularProgressIndicator(
            color: MyConstant.bluelight,
          ),
        ),
      ),
    );
  }
}