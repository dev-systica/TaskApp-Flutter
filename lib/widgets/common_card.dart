import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final double elevation;
  final Widget child;
  final double padding;
  final double radius;
  final double margin;
  final Color color;

  const CommonCard({
    Key key,
    this.elevation = 4,
    @required this.radius,
    @required this.child,
    this.padding = 10,
    this.color = Colors.white,
    this.margin = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(margin),
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Container(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
