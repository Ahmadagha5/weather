import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Shared {
  static List<String>? cities = [];

  static customToast(Color color, String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );

  static loading(Color color) {
    return Container(
      color: color,
      child: const Center(
        child: SpinKitCubeGrid(
          color: Color(0xff4632a8),
          size: 50,
        ),
      ),
    );
  }
}
