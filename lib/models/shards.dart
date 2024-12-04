import 'dart:ui';

class Shards {
  final Tri triangle;
  final double rotation;
  final Offset velocity;

  Shards(this.triangle, this.rotation, this.velocity);

  Offset getCenter(Size size) {
    return Offset(
        (triangle.p1.dx * size.width +
                triangle.p2.dx * size.width +
                triangle.p3.dx * size.width) /
            3.0,
        (triangle.p1.dy * size.height +
                triangle.p2.dy * size.height +
                triangle.p3.dy * size.height) /
            3.0);
  }

  Path toPath(Size size) => Path()
    ..moveTo(triangle.p1.dx * size.width, triangle.p1.dy * size.height)
    ..lineTo(triangle.p2.dx * size.width, triangle.p2.dy * size.height)
    ..lineTo(triangle.p3.dx * size.width, triangle.p3.dy * size.height)
    ..lineTo(triangle.p1.dx * size.width, triangle.p1.dy * size.height);
}

class Tri {
  final Offset p1;
  final Offset p2;
  final Offset p3;

  Tri(this.p1, this.p2, this.p3);

  List<Tri> split() {
    double s1 = (p2 - p1).distanceSquared;
    double s2 = (p3 - p2).distanceSquared;
    double s3 = (p1 - p3).distanceSquared;

    if (s1 > s2 && s1 > s3) {
      Offset dir = p2 - p1;
      Offset mp = p1 + dir / 2;
      return [Tri(mp, p1, p3), Tri(mp, p3, p2)];
    } else if (s2 > s1 && s2 > s3) {
      Offset dir = p3 - p2;
      Offset mp = p2 + dir / 2;
      return [
        Tri(mp, p1, p3),
        Tri(mp, p2, p1),
      ];
    } else {
      Offset dir = p1 - p3;
      Offset mp = p3 + dir / 2;
      return [
        Tri(mp, p2, p1),
        Tri(mp, p3, p2),
      ];
    }
  }

  Offset get center =>
      Offset((p1.dx + p2.dx + p3.dx) / 3.0, (p1.dy + p2.dy + p3.dy) / 3.0);
}
