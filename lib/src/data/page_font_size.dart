
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

enum ScreenType { small, medium, large }

ScreenType getScreenType(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 360) {
    return ScreenType.small;
  } else if (screenWidth >= 360 && screenWidth < 600) {
    return ScreenType.medium;
  } else {
    return ScreenType.large;
  }
}

double getFontSize(int index, context) {
  // if (getDeviceType(context) == DeviceType.large) {
  //     return 33;
  //   }  else if (getDeviceType(context) == DeviceType.small) {
  //     return 20;
  //   }else
  if( MediaQuery.of(context).orientation != Orientation.portrait){
    return 35;
  }
 else if (getScreenType(context) == ScreenType.large) {
      return 15;
    } else if (getScreenType(context) == ScreenType.small) {
      return 20;
    }else
  if (index == 1 || index == 2) {
    return 25;
  } else if (index == 145 || index == 585) {
    return 22.7;
  } else if (index == 532 || index == 533 || index == 523||index==577) {
    return 22.5;
  } else if (index == 116 || index == 156) {
    return 23.4;
  } else if (index == 56 ||
      index == 57 ||
      index == 368 ||
      index == 269 ||
      index == 372 ||
      index == 376 ||
      index == 409 ||
      index == 435 ||
      index == 444 ||

      // index == 447 ||
      index == 448 ||
      index == 527 ||
      index == 535 ||
      index == 565 ||
      index == 566 ||
      index == 569 ||
      index == 574 ||
      index == 578 ||
      index == 581 ||
      index == 584 ||
      index == 587 ||
      index == 589 ||
      index == 590 ||
      index == 592 ||
      index == 593 ||
      index == 50 ||
      index == 568) {
    return 23;
  } else if (index == 34) {
    return 23;
  } else if (index == 568) {
    return 23.1;
  } else if (index == 70) {
    return 23.5;
  } else if (index == 51 || index == 501) {
    return 23.7;
  } else if (index == 581 || index == 575) {
    return 23;
  } else if (index == 576 ||
      index == 567 ||
      index == 577 ||
      index == 371 ||
      index == 446 ||
      index == 447) {
    return 22.8;
  } else {
   
    return 23.1; 

  }
}

