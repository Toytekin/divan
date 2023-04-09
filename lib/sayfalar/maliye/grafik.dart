import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;
  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pirecePoint {
  final data = <double>[2, 4, 6, 3, 5, 1, 5, 11, 13, 17, 0, 1, 28, 52, 18];
  return data
      .mapIndexed(
          ((index, element) => PricePoint(x: index.toDouble(), y: element)))
      .toList();
}
