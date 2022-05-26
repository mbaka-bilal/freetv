import 'package:flutter/material.dart';

class DisplayBannerAdWidget extends StatelessWidget {
  //Display the Ad
  const DisplayBannerAdWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Container(
        color: Colors.blue,
      ),
    );
  }
}
