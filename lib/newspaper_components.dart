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
  final int cellCount;
  const CircularSpiralGeometry(this.extent, {this.cellCount = 49});
  Offset get origin => Offset(extent / 2, extent / 2);
  double get radius => extent / 2 - 3;
  double get turns => math.max(2.0, (math.sqrt(cellCount) - 1) / 2);
  double get lane => radius * .87 / (turns + 1);
  double get slope => lane / (2 * math.pi);
  double angle(double position) {
    final a = radius * .13 + lane / 2;
    final end = a + lane * turns;
    return (math.sqrt(a * a + position / cellCount * (end * end - a * a)) - a) /
        slope;
  }

  Offset point(double t, double offset) {
    final r = radius * .13 + slope * t + offset;
    return origin + Offset(math.cos(t + math.pi), math.sin(t + math.pi)) * r;
  }

  Offset center(int index) =>
      point((angle(index.toDouble()) + angle(index + 1.0)) / 2, lane / 2);
  Offset labelPosition(int index) => point(
    angle(index.toDouble()) +
        .16 * (angle(index + 1.0) - angle(index.toDouble())),
    lane * .22,
  );
  Path path(int index) {
    final start = angle(index.toDouble()), end = angle(index + 1.0);
    final result = Path();
    for (var step = 0; step <= 16; step++) {
      final p = point(start + (end - start) * step / 16, lane);
      if (step == 0) {
        result.moveTo(p.dx, p.dy);
      } else {
        result.lineTo(p.dx, p.dy);
      }
    }
    for (var step = 16; step >= 0; step--) {
      final p = point(start + (end - start) * step / 16, 0);
      result.lineTo(p.dx, p.dy);
    }
    return result..close();
  }

  int? hit(Offset point) {
    for (var i = 0; i < cellCount; i++) {
      if (path(i).contains(point)) {
        return i;
      }
    }
    return null;
  }
}

class CircularSpiralBoard extends StatelessWidget {
  final Map<int, String> entered;
  final Set<int> errors;
  final int selected, activeStart, activeLength;
  final int cellCount;
  final ValueChanged<int> onSelect;
  const CircularSpiralBoard({
    super.key,
    required this.entered,
    required this.errors,
    required this.selected,
    required this.activeStart,
    required this.activeLength,
    required this.onSelect,
    this.cellCount = 49,
  });
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final geometry = CircularSpiralGeometry(
              constraints.maxWidth,
              cellCount: cellCount,
            ),
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
              for (var i = 0; i < cellCount; i++)
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
    for (var i = 0; i < geometry.cellCount; i++) {
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
      text(
        canvas,
        '${i + 1}',
        geometry.labelPosition(i),
        size: geometry.extent * .020,
        color: green,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularSpiralPainter old) => true;
}

class WordSearchInk extends StatelessWidget {
  final int columns;
  final List<List<Offset>> strokes;
  final List<Offset> live;
  const WordSearchInk({
    super.key,
    required this.strokes,
    required this.live,
    this.columns = 12,
  });
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _WordSearchInkPainter(strokes, live, columns)),
  );
}

class _WordSearchInkPainter extends CustomPainter {
  final int columns;
  final List<List<Offset>> strokes;
  final List<Offset> live;
  _WordSearchInkPainter(this.strokes, this.live, this.columns);
  void draw(Canvas canvas, Size size, List<Offset> points, bool preview) {
    if (points.isEmpty) return;
    final path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    if (points.length > 1) {
      path.lineTo(points.last.dx * size.width, points.last.dy * size.height);
    }
    final width = size.width / columns;
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
