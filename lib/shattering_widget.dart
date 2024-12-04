import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'models/shards.dart';

class ShatteringWidget extends StatefulWidget {
  final Widget Function(void Function() shatter) builder;
  final void Function() onScatterComplete;
  const ShatteringWidget(
      {super.key, required this.builder, required this.onScatterComplete});

  @override
  State<ShatteringWidget> createState() => _ShatteringWidgetState();
}

class _ShatteringWidgetState extends State<ShatteringWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Random r = Random();

  List<Shards> shards = [];
  GlobalKey? key;
  ui.Image? image;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    key = GlobalKey();
    controller?.addStatusListener((state) {
      if (state.isCompleted) {
        setState(() {
          controller!.reset();
          widget.onScatterComplete();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return controller!.isAnimating
        ? AnimatedBuilder(
            animation: controller!,
            builder: (context, child) => CustomPaint(
                  size: Size(image!.width.toDouble(), image!.height.toDouble()),
                  painter: ShardPainter(image!, shards, controller!.value),
                ))
        : RepaintBoundary(key: key, child: widget.builder(shatter));
  }

  void shatter() {
    RenderRepaintBoundary boundary =
        key!.currentContext!.findRenderObject() as RenderRepaintBoundary;
    boundary.toImage().then((value) {
      setState(() {
        image = value;
        List<Tri> triangles = image!.width > image!.height
            ? [
                Tri(const Offset(0, 0), const Offset(.3, 0),
                    const Offset(0, 1.0)),
                Tri(const Offset(.3, 0), const Offset(1.0, 0),
                    const Offset(1.0, 1.0)),
                Tri(const Offset(0, 1.0), const Offset(.3, 0),
                    const Offset(1.0, 1.0)),
              ]
            : [
                Tri(const Offset(0, 0), const Offset(1.0, 0),
                    const Offset(1.0, .3)),
                Tri(const Offset(0, 0), const Offset(1.0, .3),
                    const Offset(0, 1.0)),
                Tri(const Offset(0, 1.0), const Offset(1.0, .3),
                    const Offset(1.0, 1.0)),
              ];
        shards = triangles
            .map((e) => r.nextBool() ? e.split() : [e])
            .expand((e) => e)
            .map((e) => r.nextBool() ? e.split() : [e])
            .expand((e) => e)
            .map((e) => r.nextBool() ? e.split() : [e])
            .expand((e) => e)
            .map((e) => r.nextBool() ? e.split() : [e])
            .expand((e) => e)
            .map((e) => r.nextBool() ? e.split() : [e])
            .expand((e) => e)
            .map((e) => r.nextBool() ? e.split() : [e])
            .expand((e) => e)
            .map((e) => Shards(e, -.3 + r.nextDouble() * .6,
                ((e.center - const Offset(.5, .5)) * r.nextDouble() * 600)))
            .toList();
        controller!.forward();
      });
    });
  }
}

class ShardPainter extends CustomPainter {
  final List<Shards> shards;
  final ui.Image image;
  final double progress;
  ShardPainter(this.image, this.shards, this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    Paint imagePainter = Paint()
      ..shader = ImageShader(
          image, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);

    for (Shards shard in shards) {
      Offset center = shard.getCenter(size);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(shard.rotation * progress);
      canvas.translate(-center.dx + shard.velocity.dx * progress,
          -center.dy + shard.velocity.dy * progress);

      canvas.drawPath(shard.toPath(size), imagePainter);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
