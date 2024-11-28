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
    Paint imageShader = Paint()
      ..shader = ImageShader(
          image, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);
    Rect rect =
        Rect.fromLTWH(50 * progress, 50 * progress, size.width, size.height);
    canvas.drawRect(rect, imageShader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
