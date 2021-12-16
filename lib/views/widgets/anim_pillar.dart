import 'package:flutter/material.dart';

class AnimPillar extends StatelessWidget {
  final Color color;
  final double heightFrom;
  final double heightTo;
  final double width;
  final bool isRightIn;
  final bool isTopIn;
  final double interval;
  final Duration duration;

  const AnimPillar({
    Key? key,
    this.duration = const Duration(seconds: 1),
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
    double diff = heightFrom - heightTo;
    //log("[Pillar] $key | $heightFrom $heightTo diff = $diff   ?$isTopIn");

    return SizedBox(
      width: width,
      height: heightFrom > heightTo ? heightFrom : heightTo,
      child: TweenAnimationBuilder(
          duration: duration,
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Interval(interval, 1, curve: Curves.bounceOut),
          builder: (context, double value, child) {
            double topFrom = 0;
            double topTo = 0;
            double left1 = 0;
            double left2 = 0;
            Color cf = color;
            Color ct = color;
            if (isTopIn) {
              topFrom = heightFrom - value * heightFrom;
              topTo = heightTo - value * heightTo;
            } else {
              if (diff < 0) {
                topFrom = -diff;
              } else {
                topTo = diff;
              }
            }
            if (!isTopIn) {
              left1 = isRightIn ? -width * value : width * value;
              left2 = isRightIn ? -width + width * value : width - width * value;
              cf = isRightIn ? Colors.pink.shade200 : Colors.orange.shade200;
              ct = isRightIn ? Colors.orange.shade200 : Colors.pink.shade200;
            }

            Widget from = Positioned(
              left: left1,
              top: topFrom,
              child: Container(color: cf, width: width, height: heightFrom),
            );

            Widget to = Positioned(
              left: left2,
              top: topTo,
              child: Container(
                color: ct,
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
