part of 'main.dart';

const turkishQRows = ['QWERTYUIOPĞÜ', 'ASDFGHJKLŞİ', 'ZXCVBNMÖÇ'];

class LetterKeyboard extends StatelessWidget {
  final ValueChanged<String> onLetter;
  final VoidCallback onDelete;
  const LetterKeyboard({
    super.key,
    required this.onLetter,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: paper,
      border: Border(top: BorderSide(color: rule)),
    ),
    padding: const EdgeInsets.fromLTRB(3, 6, 3, 4),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final unit = constraints.maxWidth / 12;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var row = 0; row < turkishQRows.length; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final letter in turkishQRows[row].split(''))
                    SizedBox(
                      width: unit,
                      height: 44,
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: OutlinedButton(
                          key: ValueKey('letter_$letter'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            foregroundColor: ink,
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () => onLetter(letter),
                          child: FittedBox(
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (row == 2)
                    SizedBox(
                      width: unit * 1.7,
                      height: 44,
                      child: IconButton(
                        tooltip: 'Harf sil',
                        onPressed: onDelete,
                        icon: const Icon(Icons.backspace_outlined),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    ),
  );
}

class ZoomablePaper extends StatefulWidget {
  final Widget child;
  final int gridSize;
  final int? gridRows;
  final double minimumCellSize;
  final VoidCallback? onCheck;
  const ZoomablePaper({
    super.key,
    required this.child,
    required this.gridSize,
    this.gridRows,
    this.minimumCellSize = 0,
    this.onCheck,
  });
  @override
  State<ZoomablePaper> createState() => _ZoomablePaperState();
}

class _ZoomablePaperState extends State<ZoomablePaper> {
  final controller = TransformationController();
  double viewport = 0, extent = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void zoom(double factor) {
    final old = controller.value.entry(0, 0).abs(),
        target = (old * factor).clamp(viewport / extent, 4.0);
    final t = controller.value.getTranslation(), ratio = target / old;
    final x = viewport / 2 - (viewport / 2 - t.x) * ratio,
        y = viewport / 2 - (viewport / 2 - t.y) * ratio;
    controller.value = Matrix4.diagonal3Values(target, target, 1)
      ..setTranslationRaw(x, y, 0);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      viewport = constraints.maxWidth;
      extent = math.max(viewport, widget.gridSize * widget.minimumCellSize);
      final fit = viewport / extent;
      final aspect = (widget.gridRows ?? widget.gridSize) / widget.gridSize;
      return Column(
        children: [
          SizedBox(
            width: viewport,
            height: viewport * aspect,
            child: ClipRect(
              child: InteractiveViewer(
                key: const ValueKey('cross_viewport'),
                transformationController: controller,
                constrained: false,
                minScale: fit,
                maxScale: 4,
                child: SizedBox(
                  width: extent,
                  height: extent * aspect,
                  child: widget.child,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 34,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: widget.onCheck,
                      child: const FittedBox(child: Text('Kontrol et')),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Küçült',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => zoom(1 / 1.25),
                  icon: const Icon(Icons.remove, size: 19),
                ),
                IconButton(
                  tooltip: 'Büyüt',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => zoom(1.25),
                  icon: const Icon(Icons.add, size: 19),
                ),
                IconButton(
                  tooltip: 'Tüm bulmacayı göster',
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      controller.value = Matrix4.diagonal3Values(fit, fit, 1),
                  icon: const Icon(Icons.fit_screen, size: 19),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class CircularSpiralGeometry {
  final double extent;
  const CircularSpiralGeometry(this.extent);
  static const counts = [24, 16, 8, 1];
  static const radii = [1.0, .72, .43, .16, 0.0];
  Offset get origin => Offset(extent / 2, extent / 2);
  double get radius => extent / 2 - 2;
  (int, int) ringPosition(int index) {
    var offset = 0;
    for (var ring = 0; ring < counts.length; ring++) {
      if (index < offset + counts[ring]) return (ring, index - offset);
      offset += counts[ring];
    }
    throw RangeError.index(index, List.filled(49, 0));
  }

  Offset center(int index) {
    final (ring, position) = ringPosition(index);
    if (ring == 3) return origin;
    final angle = -math.pi / 2 + (position + .5) * 2 * math.pi / counts[ring];
    final r = radius * (radii[ring] + radii[ring + 1]) / 2;
    return origin + Offset(math.cos(angle), math.sin(angle)) * r;
  }

  Path path(int index) {
    final (ring, position) = ringPosition(index);
    if (ring == 3) {
      return Path()
        ..addOval(Rect.fromCircle(center: origin, radius: radius * radii[3]));
    }
    final angle = -math.pi / 2 + position * 2 * math.pi / counts[ring],
        sweep = 2 * math.pi / counts[ring];
    final outer = radius * radii[ring], inner = radius * radii[ring + 1];
    return Path()
      ..moveTo(
        origin.dx + outer * math.cos(angle),
        origin.dy + outer * math.sin(angle),
      )
      ..arcTo(
        Rect.fromCircle(center: origin, radius: outer),
        angle,
        sweep,
        false,
      )
      ..lineTo(
        origin.dx + inner * math.cos(angle + sweep),
        origin.dy + inner * math.sin(angle + sweep),
      )
      ..arcTo(
        Rect.fromCircle(center: origin, radius: inner),
        angle + sweep,
        -sweep,
        false,
      )
      ..close();
  }

  int? hit(Offset point) {
    for (var i = 0; i < 49; i++) {
      if (path(i).contains(point)) return i;
    }
    return null;
  }
}

class CircularSpiralBoard extends StatelessWidget {
  final Map<int, String> entered;
  final Set<int> errors;
  final int selected, activeStart, activeLength;
  final ValueChanged<int> onSelect;
  const CircularSpiralBoard({
    super.key,
    required this.entered,
    required this.errors,
    required this.selected,
    required this.activeStart,
    required this.activeLength,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final geometry = CircularSpiralGeometry(constraints.maxWidth),
            letterBox = constraints.maxWidth * .085;
        return GestureDetector(
          onTapUp: (details) {
            final index = geometry.hit(details.localPosition);
            if (index != null) onSelect(index);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CircularSpiralPainter(
                    geometry,
                    selected,
                    activeStart,
                    activeLength,
                    errors,
                  ),
                ),
              ),
              for (var i = 0; i < 49; i++)
                Positioned(
                  left: geometry.center(i).dx - letterBox / 2,
                  top: geometry.center(i).dy - letterBox / 2,
                  width: letterBox,
                  height: letterBox,
                  child: Semantics(
                    label: '${i + 1}. kutu, ${entered[i] ?? 'boş'}',
                    button: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onSelect(i),
                      child: SizedBox(
                        key: ValueKey('spiral_$i'),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              entered[i] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: errors.contains(i)
                                    ? Colors.red.shade800
                                    : ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}

class _CircularSpiralPainter extends CustomPainter {
  final CircularSpiralGeometry geometry;
  final int selected, activeStart, activeLength;
  final Set<int> errors;
  _CircularSpiralPainter(
    this.geometry,
    this.selected,
    this.activeStart,
    this.activeLength,
    this.errors,
  );
  void text(
    Canvas canvas,
    String text,
    Offset center, {
    double size = 9,
    Color color = ink,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'serif',
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 49; i++) {
      final path = geometry.path(i), current = i == selected;
      canvas.drawPath(
        path,
        Paint()
          ..color = current
              ? const Color(0xFFD3AE68)
              : i >= activeStart && i < activeStart + activeLength
              ? selectedPaper
              : Colors.white,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = current ? rust : rule
          ..style = PaintingStyle.stroke
          ..strokeWidth = current ? 2 : .75,
      );
      final number = spiralStarts.indexOf(i);
      if (number >= 0) {
        text(
          canvas,
          '${number + 1}',
          geometry.center(i) +
              Offset(-geometry.extent * .023, -geometry.extent * .035),
          size: geometry.extent * .023,
        );
      }
    }
    // Dış halkadan bir iç halkaya geçilen üç noktayı göster.
    for (final i in [23, 39, 47]) {
      final p = geometry.center(i), q = geometry.center(i + 1);
      final direction = (q - p) / (q - p).distance;
      final start = p + direction * 11, end = q - direction * 12;
      final paint = Paint()
        ..color = rust
        ..strokeWidth = 1.3;
      canvas.drawLine(start, end, paint);
      final normal = Offset(-direction.dy, direction.dx);
      canvas.drawLine(end, end - direction * 5 + normal * 3, paint);
      canvas.drawLine(end, end - direction * 5 - normal * 3, paint);
    }
    canvas.drawCircle(
      geometry.origin,
      geometry.radius,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularSpiralPainter old) => true;
}

class WordSearchInk extends StatelessWidget {
  final List<List<Offset>> strokes;
  final List<Offset> live;
  const WordSearchInk({super.key, required this.strokes, required this.live});
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _WordSearchInkPainter(strokes, live)),
  );
}

class _WordSearchInkPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> live;
  _WordSearchInkPainter(this.strokes, this.live);
  void draw(Canvas canvas, Size size, List<Offset> points, bool preview) {
    if (points.isEmpty) return;
    final path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    if (points.length > 1) {
      path.lineTo(points.last.dx * size.width, points.last.dy * size.height);
    }
    final width = size.width / searchGrid.first.length;
    final marker = Paint()
      ..color = preview ? const Color(0x889E5233) : const Color(0x886F8750)
      ..strokeWidth = width * .67
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    if (points.length == 1) {
      canvas.drawCircle(
        Offset(points.first.dx * size.width, points.first.dy * size.height),
        width * .3,
        marker..style = PaintingStyle.fill,
      );
    } else {
      canvas.drawPath(path, marker);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      draw(canvas, size, stroke, false);
    }
    draw(canvas, size, live, true);
  }

  @override
  bool shouldRepaint(covariant _WordSearchInkPainter old) => true;
}
