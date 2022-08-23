import 'package:flutter/material.dart';

import '../universes/Constant.dart';

class ShowProgress extends StatelessWidget {
  const ShowProgress({Key? key}) : super(key: key);

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
