import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CircleProgress extends StatelessWidget {
  final double size;
final Color color;

  const CircleProgress({Key key, @required this.size, this.color = Colors.pink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(size: size, color: color);
  }
}
