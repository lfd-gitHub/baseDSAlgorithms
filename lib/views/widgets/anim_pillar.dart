import 'package:flutter/material.dart';

class AnimPillar extends StatelessWidget {
  final Color color;
  final double heightFrom;
  final double heightTo;
  final double width;
  final bool isRightIn;
  final bool isTopIn;
  final double interval;

  const AnimPillar({
    Key? key,
    this.color = Colors.blue,
    this.heightFrom = 100,
    this.heightTo = 100,
    this.width = 10,
    this.isRightIn = false,
    this.isTopIn = true,
    this.interval = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heightFrom > heightTo ? heightFrom : heightTo,
      child: TweenAnimationBuilder(
          duration: const Duration(seconds: 1),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Interval(interval, 1, curve: Curves.bounceOut),
          builder: (context, double value, child) {
            double top = 0;
            double left1 = 0;
            double left2 = 0;
            if (isTopIn) top = heightFrom - value * heightFrom;
            if (!isTopIn) {
              left1 = isRightIn ? -width * value : width * value;
              left2 = isRightIn ? -width + width * value : width - width * value;
            }

            Widget from = Positioned(
              left: left1,
              top: top,
              child: Container(color: color, width: width, height: heightFrom),
            );

            Widget to = Positioned(
              left: left2,
              top: top,
              child: Container(
                color: color,
                width: width,
                height: heightTo,
              ),
            );

            return Stack(
              children: [isRightIn ? from : to, isRightIn ? to : from],
            );
          }),
    );
  }
}
