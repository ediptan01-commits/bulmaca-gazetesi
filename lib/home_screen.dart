part of 'main.dart';

/// Verilen tasarımın özgün çizimleri; tüm etkileşimler gerçek Flutter kontrolleridir.
const homeArtwork = 'assets/ui/home-reference.png';
const dashboardBlue = Color(0xFF0066BA);
const dashboardNavy = Color(0xFF071C50);
const dashboardGold = Color(0xFFFFD83E);
const cardRegions = <Rect>[
  Rect.fromLTWH(23, 637, 323, 359),
  Rect.fromLTWH(356, 637, 315, 359),
  Rect.fromLTWH(681, 637, 322, 359),
  Rect.fromLTWH(23, 1013, 323, 366),
  Rect.fromLTWH(356, 1013, 315, 366),
  Rect.fromLTWH(681, 1013, 322, 366),
];

class ReferenceArtwork extends StatelessWidget {
  final Rect region;
  const ReferenceArtwork({super.key, required this.region});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: LayoutBuilder(
      builder: (context, box) => ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: -region.left / region.width * box.maxWidth,
              top: -region.top / region.height * box.maxHeight,
              width: 1024 / region.width * box.maxWidth,
              height: 1536 / region.height * box.maxHeight,
              child: Image.asset(
                homeArtwork,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DailyGameProgress {
  static String get day {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  static Future<Set<String>> read() async {
    try {
      final raw = jsonDecode(await Store.read('daily_$day') ?? '[]');
      if (raw is List) {
        return raw
            .whereType<String>()
            .where((id) => puzzles.any((p) => p.id == id))
            .toSet();
      }
    } catch (_) {
      /* Eksik veya bozuk günlük kayıt yeni görevle açılır. */
    }
    return {};
  }

  static Future<void> record(String id) async {
    final found = await read();
    found.add(id);
    await Store.write('daily_$day', jsonEncode(found.toList()));
    if (found.length >= 3 && await Store.read('daily_reward_$day') != '1') {
      await Store.write('daily_reward_$day', '1');
      final stars = int.tryParse(await Store.read('daily_stars') ?? '0') ?? 0;
      await Store.write('daily_stars', '${stars + 1}');
    }
  }
}

class IllustratedHome extends StatefulWidget {
  final Map<String, int> completed;
  final Future<void> Function(Puzzle) onOpen;
  const IllustratedHome({
    super.key,
    required this.completed,
    required this.onOpen,
  });
  @override
  State<IllustratedHome> createState() => _IllustratedHomeState();
}

class _IllustratedHomeState extends State<IllustratedHome> {
  Set<String> daily = {};
  int stars = 0;
  bool haptics = false;
  int get total => widget.completed.values.fold(0, (a, b) => a + b);
  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final today = await DailyGameProgress.read();
    final earned = int.tryParse(await Store.read('daily_stars') ?? '0') ?? 0;
    final enabled = await Store.read('haptics') == '1';
    if (mounted) {
      setState(() {
        daily = today;
        stars = earned;
        haptics = enabled;
      });
    }
  }

  void feedback() {
    if (haptics) {
      HapticFeedback.selectionClick();
    }
  }

  Future<void> open(Puzzle p) async {
    feedback();
    await widget.onOpen(p);
    await refresh();
  }

  Future<void> panel(String title, List<Widget> children) async {
    feedback();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F8FF),
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: dashboardNavy,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void profile() => panel('Profil', [
    const Icon(Icons.account_circle, size: 68, color: dashboardBlue),
    const Text(
      'Bulmaca Oyuncusu',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 18),
    Text('$total / 12 bölüm tamamlandı', textAlign: TextAlign.center),
    Text('$stars günlük yıldız', textAlign: TextAlign.center),
    const SizedBox(height: 12),
    const Text('İlerlemen bu cihazda kaydedilir.', textAlign: TextAlign.center),
  ]);
  void achievements() => panel('Başarılar', [
    Text(
      '$total / 12 bölüm tamamlandı',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    LinearProgressIndicator(value: total / 12, color: dashboardBlue),
    const SizedBox(height: 16),
    for (final p in puzzles)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          (widget.completed[p.id] ?? 0) == 2
              ? Icons.emoji_events
              : Icons.extension_outlined,
          color: (widget.completed[p.id] ?? 0) == 2
              ? const Color(0xFFD49B00)
              : dashboardBlue,
        ),
        title: Text(p.name),
        trailing: Text('${widget.completed[p.id] ?? 0} / 2'),
      ),
    Text('Kazanılan günlük yıldız: $stars'),
  ]);
  void settings() => panel('Ayarlar', [
    StatefulBuilder(
      builder: (context, setLocal) => SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Dokunma titreşimi'),
        value: haptics,
        onChanged: (value) {
          setLocal(() => haptics = value);
          setState(() => haptics = value);
          Store.write('haptics', value ? '1' : '0');
        },
      ),
    ),
    const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(appName),
      subtitle: Text(appSlogan),
    ),
    const Text(
      '6 bulmaca türü • 12 bölüm\nHer türde 2 oynanabilir bölüm. İlerleme cihazda saklanır.',
    ),
  ]);
  void challenge() => panel('Bugünün Zihin Görevi', [
    Text(
      '${math.min(daily.length, 3)} / 3 farklı bulmaca türü tamamlandı',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    LinearProgressIndicator(
      value: math.min(daily.length / 3, 1),
      color: const Color(0xFF38C900),
    ),
    const SizedBox(height: 14),
    Text(
      daily.length >= 3
          ? 'Günlük yıldızını kazandın! ★'
          : 'Bugün 3 farklı türde bulmaca bitir, 1 günlük yıldız kazan.',
    ),
    for (final p in puzzles)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          daily.contains(p.id) ? Icons.check_circle : Icons.play_circle_fill,
          color: dashboardBlue,
        ),
        title: Text(p.name),
        onTap: () {
          Navigator.pop(context);
          open(p);
        },
      ),
  ]);
  Future<void> collection() async {
    feedback();
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: dashboardBlue,
          appBar: AppBar(title: const Text('Bulmacalar')),
          body: SafeArea(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: puzzles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .89,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, i) => Semantics(
                button: true,
                label:
                    '${puzzles[i].name}, ${widget.completed[puzzles[i].id] ?? 0}/2 bölüm',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: ValueKey('collection_${puzzles[i].id}'),
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => open(puzzles[i]),
                    child: ReferenceArtwork(region: cardRegions[i]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await refresh();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: dashboardBlue,
      systemNavigationBarColor: const Color(0xFF004C96),
    ),
    child: Scaffold(
      backgroundColor: dashboardBlue,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final width = math.min(box.maxWidth, 1024.0);
            final height = math.max(box.maxHeight, width * 1472 / 1024);
            Rect scaled(Rect original) => Rect.fromLTWH(
              original.left / 1024 * width,
              (original.top - 64) / 1472 * height,
              original.width / 1024 * width,
              original.height / 1472 * height,
            );
            Widget action(
              Rect bounds,
              String label,
              String key,
              VoidCallback tap,
            ) => Positioned.fromRect(
              rect: scaled(bounds),
              child: Semantics(
                button: true,
                label: label,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: ValueKey(key),
                    onTap: tap,
                    borderRadius: BorderRadius.circular(24),
                    splashColor: dashboardGold.withValues(alpha: .25),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            );
            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: ReferenceArtwork(
                          region: Rect.fromLTWH(0, 64, 1024, 1472),
                        ),
                      ),
                      Positioned.fromRect(
                        rect: scaled(const Rect.fromLTWH(299, 477, 389, 29)),
                        child: Semantics(
                          label: 'Günlük görev',
                          value: '${math.min(daily.length, 3)}/3',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: math.min(daily.length / 3, 1),
                              backgroundColor: const Color(0xFF0053A3),
                              color: const Color(0xFF3DE900),
                            ),
                          ),
                        ),
                      ),
                      action(
                        const Rect.fromLTWH(29, 92, 100, 100),
                        'Profil',
                        'home_profile',
                        profile,
                      ),
                      action(
                        const Rect.fromLTWH(796, 92, 100, 100),
                        'Başarılar',
                        'home_crown',
                        achievements,
                      ),
                      action(
                        const Rect.fromLTWH(909, 92, 95, 100),
                        'Ayarlar',
                        'home_settings',
                        settings,
                      ),
                      action(
                        const Rect.fromLTWH(25, 291, 977, 255),
                        'Günlük Meydan Okuma, Oyna',
                        'home_daily',
                        challenge,
                      ),
                      for (var i = 0; i < puzzles.length; i++)
                        action(
                          cardRegions[i],
                          '${puzzles[i].name}, ${widget.completed[puzzles[i].id] ?? 0}/2 bölüm',
                          'home_puzzle_${puzzles[i].id}',
                          () => open(puzzles[i]),
                        ),
                      action(
                        const Rect.fromLTWH(24, 1397, 213, 125),
                        'Ana Sayfa',
                        'nav_home',
                        () {
                          feedback();
                          refresh();
                        },
                      ),
                      action(
                        const Rect.fromLTWH(238, 1397, 270, 125),
                        'Bulmacalar',
                        'nav_puzzles',
                        collection,
                      ),
                      action(
                        const Rect.fromLTWH(509, 1397, 250, 125),
                        'Başarılar',
                        'nav_achievements',
                        achievements,
                      ),
                      action(
                        const Rect.fromLTWH(760, 1397, 242, 125),
                        'Profil',
                        'nav_profile',
                        profile,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
