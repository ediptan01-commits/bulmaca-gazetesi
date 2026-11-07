part of 'main.dart';

const _squareRule = Color(0xFF8D2927);
const _squareBlock = Color(0xFF08064D);

class NumberedSquareBoard extends StatelessWidget {
  final Widget Function(int, int) cell;
  const NumberedSquareBoard({super.key, required this.cell});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              for (var column = 1; column <= 10; column++)
                Expanded(child: _coordinate(column)),
            ],
          ),
        ),
        for (var row = 0; row < 10; row++)
          Expanded(
            child: Row(
              children: [
                Expanded(child: _coordinate(row + 1)),
                for (var column = 0; column < 10; column++)
                  Expanded(child: cell(row, column)),
              ],
            ),
          ),
      ],
    ),
  );

  Widget _coordinate(int value) =>
      Center(child: Text('$value', style: const TextStyle(fontSize: 13)));
}

class _ArrowQuestionPanel extends StatelessWidget {
  final List<int> hints;
  final List<WordEntry> words;
  final int active;
  final ValueChanged<int> choose;
  const _ArrowQuestionPanel({
    required this.hints,
    required this.words,
    required this.active,
    required this.choose,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFFFF2B7),
      border: Border.all(color: rule, width: .5),
    ),
    child: Column(
      children: [
        for (final index in hints)
          Expanded(
            child: Semantics(
              excludeSemantics: true,
              label:
                  '${words[index].clue}, ${words[index].vertical ? 'aşağı' : 'sağa'}',
              button: true,
              child: InkWell(
                key: ValueKey('arrow_clue_$index'),
                onTap: () => choose(index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: index == active ? const Color(0xFFFFDE7A) : null,
                    border: index != hints.last
                        ? const Border(
                            bottom: BorderSide(color: rule, width: .5),
                          )
                        : null,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SizedBox(
                                width: 48,
                                child: Text(
                                  words[index].clue,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          words[index].vertical ? '↓' : '→',
                          style: const TextStyle(
                            fontSize: 9,
                            height: 1,
                            color: Color(0xFFAC3B25),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

// Question panels span the unused neighboring space; letter cells stay square.
// Gazete cengeli: sabit 8 sutun, 11 satir. Soru ve cevaplar
// komsu hucresini yutup buyuyemez; her hucresinin boyu esittir.
List<List<(int, int, int)>> arrowPanelRows(List<WordEntry> words) {
  return List.generate(
    arrowRows,
    (r) => List.generate(arrowSize, (c) => (c, 1, c)),
  );
}

class ArrowPaperGrid extends StatelessWidget {
  final List<WordEntry> words;
  final Widget Function(int, int, int, int) cell;
  const ArrowPaperGrid({super.key, required this.words, required this.cell});
  @override
  Widget build(BuildContext context) {
    final panels = arrowPanelRows(words);
    return AspectRatio(
      aspectRatio: arrowSize / arrowRows,
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: ink)),
        child: Column(
          children: [
            for (var r = 0; r < arrowRows; r++)
              Expanded(
                child: Row(
                  children: [
                    for (final panel in panels[r])
                      Expanded(
                        flex: panel.$2,
                        child: cell(r, panel.$3, panel.$2, panel.$3 - panel.$1),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
