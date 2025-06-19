import 'package:image/image.dart';

void simpleFloodFill(Image image, int x, int y, int targetColor, int replacementColor) {
  if (targetColor == replacementColor) return;

  bool isTransparent(int color) => getAlpha(color) == 0;

  final width = image.width;
  final height = image.height;
  final stack = <_Point>[];

  stack.add(_Point(x, y));

  while (stack.isNotEmpty) {
    final point = stack.removeLast();
    final px = point.x;
    final py = point.y;

    if (px < 0 || px >= width || py < 0 || py >= height) continue;

    final currentColor = image.getPixel(px, py);
    if (!isTransparent(currentColor)) continue;

    image.setPixel(px, py, replacementColor);

    stack.add(_Point(px + 1, py));
    stack.add(_Point(px - 1, py));
    stack.add(_Point(px, py + 1));
    stack.add(_Point(px, py - 1));
  }
}

class _Point {
  final int x;
  final int y;

  _Point(this.x, this.y);
}
