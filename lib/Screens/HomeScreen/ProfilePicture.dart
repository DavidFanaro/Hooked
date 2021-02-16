import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {

  final Image pic;

  const ProfilePicture({
    this.pic,
    Key key,
  }) : super(key: key);
  
  

  @override
  Widget build(BuildContext context) {

    BorderRadius _br = BorderRadius.all(Radius.circular(45));

    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: _br,
        color: Colors.white
        ),
      child: pic == null ? Image.asset("Images/fish-8-xxl.png") : 
      ClipRRect(
        borderRadius: _br,
        child: pic
      ),
      );
  }
}