import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:projects/Utils/flood_fill.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtCanvas extends StatefulWidget {
  final Color selectedColor;
  final String imagePath;

  const ArtCanvas({
    super.key,
    required this.selectedColor,
    required this.imagePath,
  });

  @override
  State<ArtCanvas> createState() => ArtCanvasState();
}

class ArtCanvasState extends State<ArtCanvas> {
  late ui.Image displayImage;
  late img.Image fillImage;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ArtCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() => isLoaded = false);
    try {
      final data = await rootBundle.load(widget.imagePath);
      final bytes = data.buffer.asUint8List();

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      displayImage = frame.image;

      fillImage = img.decodeImage(bytes)!;

      setState(() => isLoaded = true);
    } catch (e) {
      print("❌ Error loading image: $e");
    }
  }

  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    if (!isLoaded) return;

    final localPosition = details.localPosition;
    final scaleX = displayImage.width / constraints.maxWidth;
    final scaleY = displayImage.height / constraints.maxHeight;

    final dx = (localPosition.dx * scaleX).toInt();
    final dy = (localPosition.dy * scaleY).toInt();

    final targetColor = fillImage.getPixelSafe(dx, dy);
    final fillColor = img.getColor(
      widget.selectedColor.red,
      widget.selectedColor.green,
      widget.selectedColor.blue,
    );

    if (targetColor != fillColor) {
      simpleFloodFill(fillImage, dx, dy, targetColor, fillColor);
      _convertImage(fillImage).then((updatedImage) {
        setState(() {
          displayImage = updatedImage;
        });
      });
    }
  }

  Future<ui.Image> _convertImage(img.Image image) async {
    final pngBytes = Uint8List.fromList(img.encodePng(image));
    final codec = await ui.instantiateImageCodec(pngBytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<void> saveArtwork() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/artwork_$timestamp.png';

      final pngBytes = img.encodePng(fillImage);
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      print("✅ Artwork saved to $filePath");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saved1)),
        );
      }
    } catch (e) {
      print("❌ Failed to save artwork: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save artwork ❌")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return GestureDetector(
          onTapDown: (details) => _handleTapDown(details, constraints),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isLoaded
                ? CustomPaint(
              size: Size.infinite,
              painter: _ImagePainter(displayImage),
            )
                : const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;

  _ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final src =
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
