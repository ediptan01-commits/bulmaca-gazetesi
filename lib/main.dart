import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const BulmacaApp());
const paper = Color(0xFFF7F0E2);
const ink = Color(0xFF292820);
const rust = Color(0xFF9E5233);
const green = Color(0xFF50735A);

String trUpper(String s) => s.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

class Store {
  static final _prefs = SharedPreferencesAsync();
  static Future<String?> read(String key) => _prefs.getString(key);
  static Future<void> write(String key, String val) => _prefs.setString(key, val);
  static Future<bool> done(String id) async => (await read('done_$id')) == '1';
  static Future<void> complete(String id) => write('done_$id', '1');
}

class Puzzle {
  final String id, name, subtitle, emoji;
  const Puzzle(this.id, this.name, this.subtitle, this.emoji);
}
const puzzles = <Puzzle>[
  Puzzle('cengel', 'Çengel Bulmaca', 'İpuçlarından kutucuklara', '🧩'),
  Puzzle('kare', 'Kare Bulmaca', 'Kesişen kelimeleri çöz', '🔠'),
  Puzzle('sudoku', 'Sudoku', '1–9 sayı mantığı', '🔢'),
  Puzzle('av', 'Kelime Avı', 'Harflere dokunarak bul', '🔎'),
  Puzzle('sarmal', 'Sarmal Bulmaca', 'İç içe ilerleyen kelimeler', '🌀'),
  Puzzle('resim', 'Resimli Bulmaca', 'Emoji ipuçlarını çöz', '🖼️'),
];

class BulmacaApp extends StatelessWidget {
  const BulmacaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Bulmaca Gazetesi', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: rust, surface: paper),
      appBarTheme: const AppBarTheme(backgroundColor: paper, foregroundColor: ink),
      cardTheme: CardThemeData(color: const Color(0xFFFFFAF0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ), home: const Home());
}

class Home extends StatefulWidget { const Home({super.key}); @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home> {
  int tab = 0;
  Set<String> complete = {};
  @override void initState() {super.initState(); refresh();}
  Future<void> refresh() async {
    final ids = <String>{};
    for (final p in puzzles) {if (await Store.done(p.id)) ids.add(p.id);}
    if(mounted) setState(()=>complete=ids);
  }
  void open(Puzzle p) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_)=>PuzzleScreen(puzzle:p)));
    refresh();
  }
  @override Widget build(BuildContext context) {
    final today = DateTime.now();
    final date = '${today.day.toString().padLeft(2,'0')}.${today.month.toString().padLeft(2,'0')}.${today.year}';
    return Scaffold(appBar: AppBar(title: const Text('BULMACA GAZETESİ', style: TextStyle(fontFamily:'serif', fontWeight:FontWeight.w900, letterSpacing:1)),centerTitle:true),
      body: SafeArea(child: tab==0 ? ListView(padding:const EdgeInsets.all(16),children:[
        Container(padding:const EdgeInsets.all(19),decoration:BoxDecoration(color:const Color(0xFFFFFBF1),border:Border.all(color:ink,width:2)),child:Column(children:[
          const Text('GÜNLÜK BULMACA',style:TextStyle(fontFamily:'serif',fontSize:30,fontWeight:FontWeight.bold)),
          const Divider(color:ink,thickness:2),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text('SAYI 001 • $date',style:const TextStyle(fontSize:12)),const Text('HER GÜN BEYİN EGZERSİZİ',style:TextStyle(fontSize:10))]),
          const SizedBox(height:18),const Icon(Icons.auto_stories,size:72,color:rust),
          const SizedBox(height:8),const Text('Bir sayfa, altı farklı macera.',textAlign:TextAlign.center,style:TextStyle(fontFamily:'serif',fontSize:23)),
          const SizedBox(height:12),Text('${complete.length} / 6 bulmaca tamamlandı',style:const TextStyle(color:green,fontWeight:FontWeight.bold)),
          const SizedBox(height:12),LinearProgressIndicator(value:complete.length/6,color:green,backgroundColor:Colors.black12),
        ])),
        const SizedBox(height:18),const Text('BUGÜNÜN SAYFALARI',style:TextStyle(fontFamily:'serif',fontSize:21,fontWeight:FontWeight.bold)),
        ...puzzles.map((p)=>Card(child:ListTile(leading:Text(p.emoji,style:const TextStyle(fontSize:28)),title:Text(p.name,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(p.subtitle),trailing:Icon(complete.contains(p.id)?Icons.check_circle:Icons.chevron_right,color:complete.contains(p.id)?green:ink),onTap:()=>open(p)))),
        const SizedBox(height:12),const Text('İlk sürüm: Bu sayıda yer alan bulmacalar sabit örnek içeriktir. Yeni günlük sayılar sonraki güncellemede eklenecek.',style:TextStyle(fontSize:12,color:Colors.black54)),
      ]) : GridView.builder(padding:const EdgeInsets.all(14),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,childAspectRatio:0.92,crossAxisSpacing:12,mainAxisSpacing:12),itemCount:puzzles.length,itemBuilder:(ctx,i){final p=puzzles[i];return InkWell(onTap:()=>open(p),child:Card(child:Padding(padding:const EdgeInsets.all(13),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(p.emoji,style:const TextStyle(fontSize:44)),const SizedBox(height:10),Text(p.name,textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:7),Text(complete.contains(p.id)?'✓ Tamamlandı':p.subtitle,textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:complete.contains(p.id)?green:Colors.black54))]))));}),
      ),bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [NavigationDestination(icon:Icon(Icons.newspaper),label:'Gazete'),NavigationDestination(icon:Icon(Icons.grid_view),label:'Kategoriler')]),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
 final Puzzle puzzle;
 const PuzzleScreen({super.key,required this.puzzle});
 @override State<PuzzleScreen> createState()=>_PuzzleScreenState();
}
class _PuzzleScreenState extends State<PuzzleScreen> {
 bool done=false;
 @override void initState(){super.initState();load();}
 Future<void> load()async{final d=await Store.done(widget.puzzle.id);if(mounted)setState(()=>done=d);}
 Future<void> solved() async {if(done)return;await Store.complete(widget.puzzle.id);if(!mounted)return;setState(()=>done=true);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Tebrikler! Bulmaca tamamlandı.')));}
 @override Widget build(BuildContext context){
 final Widget game = switch(widget.puzzle.id) {
   'cengel' => CrossGame(key: const ValueKey('cengel'), arrow: true, onSolved: solved),
   'kare' => CrossGame(key: const ValueKey('kare'), arrow: false, onSolved: solved),
   'sudoku' => SudokuGame(onSolved: solved),
   'av' => SearchGame(onSolved: solved),
   'sarmal' => SpiralGame(onSolved: solved),
   _ => PictureGame(onSolved: solved),
 };
 return Scaffold(appBar:AppBar(title:Text(widget.puzzle.name),actions:[if(done)const Padding(padding:EdgeInsets.only(right:16),child:Icon(Icons.verified,color:green))]),body:SafeArea(child:ListView(padding:const EdgeInsets.all(14),children:[Text(widget.puzzle.subtitle,style:const TextStyle(color:Colors.black54)),const SizedBox(height:14),game])));
 }
}

// İki farklı soru düzeni; kesişen karelerde tek harf saklanır.
class WordEntry {
 final String text, clue;final int r,c;final bool vertical;
 const WordEntry(this.text,this.clue,this.r,this.c,this.vertical);
}
const crossWords = [
 WordEntry('KEDİ','Evcil, miyavlayan hayvan',0,1,false),
 WordEntry('DENİZ','Tuzlu büyük su kütlesi',0,3,true),
 WordEntry('NANE','Ferahlık veren kokulu bitki',2,3,false),
 WordEntry('ZARF','Mektubun konduğu kâğıt kılıf',4,3,false),
];
const arrowWords = [
 WordEntry('KALEM','Yazı yazmaya yarayan araç',0,0,false),
 WordEntry('ARMUT','Bir meyve',0,1,true),
 WordEntry('MUTFAK','Yemek hazırlanan oda',2,1,false),
 WordEntry('TOP','Oyunlarda kullanılan yuvarlak nesne',4,1,true),
];
class CrossGame extends StatefulWidget {
 final bool arrow;final VoidCallback onSolved;
 const CrossGame({super.key,required this.arrow,required this.onSolved});
 @override State<CrossGame> createState()=>_CrossGameState();
}
class _CrossGameState extends State<CrossGame> {
 late final words=widget.arrow?arrowWords:crossWords;
 final Map<String,String> filled={};int active=0;int selected=0;
 String id(int r,int c)=>'$r,$c';
 List<(int,int)> cells(WordEntry w)=>List.generate(w.text.length,(i)=>(w.r+(w.vertical?i:0),w.c+(w.vertical?0:i)));
 Map<String,String> get solution {final out=<String,String>{};for(final w in words){for(var i=0;i<w.text.length;i++){final (r,c)=cells(w)[i];out[id(r,c)]=w.text[i];}}return out;}
 void type(String char){final cell=cells(words[active])[selected];setState(()=>filled[id(cell.$1,cell.$2)]=char); if(selected<words[active].text.length-1)setState(()=>selected++);save();}
 Future<void> save()async{await Store.write('cross_${widget.arrow}',jsonEncode(filled));}
 @override void initState(){super.initState();restore();}
 Future<void> restore()async{final data=await Store.read('cross_${widget.arrow}');if(data!=null){try{final raw=jsonDecode(data) as Map<String,dynamic>;if(mounted)setState(()=>filled.addAll(raw.map((k,v)=>MapEntry(k,v.toString()))));}catch(_){}}}
 void check(){final ok=solution.entries.every((e)=>filled[e.key]==e.value);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(ok?'Tüm cevaplar doğru!':'Bazı kareler boş veya hatalı.')));if(ok)widget.onSolved();}
 @override Widget build(BuildContext context){final sol=solution;final entries=words;return Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
  Text(widget.arrow?'Çengel tarzı: İpucunu seç, ok yönünde doldur.':'Kare bulmaca: Kesişen kelimelerin ortak harflerini bul.',style:const TextStyle(fontSize:13)),const SizedBox(height:12),
  AspectRatio(aspectRatio:1,child:GridView.builder(physics:const NeverScrollableScrollPhysics(),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:7),itemCount:49,itemBuilder:(ctx,i){final r=i~/7,c=i%7,k=id(r,c),has=sol.containsKey(k),activeCells=cells(entries[active]);final activeCell=activeCells.any((p)=>p.$1==r&&p.$2==c);return GestureDetector(onTap:has?(){final idx=entries.indexWhere((w)=>cells(w).any((p)=>p.$1==r&&p.$2==c));setState((){active=idx<0?active:idx;selected=cells(entries[active]).indexWhere((p)=>p.$1==r&&p.$2==c);});}:null,child:Container(margin:const EdgeInsets.all(1),alignment:Alignment.center,decoration:BoxDecoration(color:!has?ink:activeCell?const Color(0xFFE6D4AF):Colors.white,border:Border.all(color:ink,width:0.5)),child:Text(filled[k]??'',style:const TextStyle(fontSize:19,fontWeight:FontWeight.bold))));})),
  const SizedBox(height:12),const Text('İPUÇLARI',style:TextStyle(fontWeight:FontWeight.bold)),
  ...List.generate(words.length,(i){final w=words[i];return Card(color:active==i?const Color(0xFFE6D4AF):null,child:ListTile(dense:true,title:Text('${i+1}. ${w.clue}'),subtitle:Text('${w.text.length} harf • ${w.vertical?'↓ Dikey':'→ Yatay'}'),onTap:()=>setState((){active=i;selected=0;})));}),
  const Text('HARFLER',style:TextStyle(fontWeight:FontWeight.bold)),Wrap(spacing:5,runSpacing:5,children:[...'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ'.split('').map((x)=>SizedBox(width:38,height:40,child:OutlinedButton(style:OutlinedButton.styleFrom(padding:EdgeInsets.zero),onPressed:()=>type(x),child:Text(x)))),SizedBox(width:58,height:40,child:IconButton(icon:const Icon(Icons.backspace_outlined),onPressed:(){final cell=cells(words[active])[selected];setState(()=>filled.remove(id(cell.$1,cell.$2)));save();}))]),
  const SizedBox(height:12),FilledButton(onPressed:check,child:const Text('Cevapları kontrol et')),
 ]);}
}

const sudokuSolved = ['534678912','672195348','198342567','859761423','426853791','713924856','961537284','287419635','345286179'];
const sudokuGivens = ['530070000','600195000','098000060','800060003','400803001','700020006','060000280','000419005','000080079'];
class SudokuGame extends StatefulWidget {final VoidCallback onSolved; const SudokuGame({super.key,required this.onSolved}); @override State<SudokuGame> createState()=>_SudokuGameState();}
class _SudokuGameState extends State<SudokuGame>{
 late List<List<int>> board;int row=0,col=0;bool notes=false;final notesMap=<String,Set<int>>{};
 @override void initState(){super.initState();board=sudokuGivens.map((s)=>s.split('').map(int.parse).toList()).toList();restore();}
 Future<void> restore()async{final raw=await Store.read('sudoku_board');if(raw!=null&&raw.length==81&&RegExp(r'^[0-9]{81}$').hasMatch(raw)){if(mounted)setState((){for(var i=0;i<81;i++){if(sudokuGivens[i~/9][i%9]=='0')board[i~/9][i%9]=int.parse(raw[i]);}});}}
 void put(int n){if(sudokuGivens[row][col]!='0')return;setState((){if(notes&&n!=0){notesMap.putIfAbsent('$row,$col',()=>{}).add(n);}else{board[row][col]=n;notesMap.remove('$row,$col');}});Store.write('sudoku_board',board.map((r)=>r.join()).join());}
 void check(){final ok=List.generate(9,(r)=>List.generate(9,(c)=>board[r][c]==int.parse(sudokuSolved[r][c])).every((v)=>v)).every((v)=>v);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(ok?'Sudoku tamamlandı!':'Henüz doğru tamamlanmadı.')));if(ok)widget.onSolved();}
 @override Widget build(BuildContext context)=>Column(children:[
 AspectRatio(aspectRatio:1,child:GridView.builder(physics:const NeverScrollableScrollPhysics(),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:9),itemCount:81,itemBuilder:(ctx,i){final r=i~/9,c=i%9,fixed=sudokuGivens[r][c]!='0';final selected=r==row&&c==col;final wrong=board[r][c]!=0&&board[r][c]!=int.parse(sudokuSolved[r][c]);return GestureDetector(onTap:()=>setState((){row=r;col=c;}),child:Container(alignment:Alignment.center,decoration:BoxDecoration(color:selected?const Color(0xFFF0D497):((r~/3+c~/3)%2==0?Colors.white:const Color(0xFFF2E9D7)),border:Border(left:BorderSide(color:ink,width:c%3==0?2:0.3),top:BorderSide(color:ink,width:r%3==0?2:0.3),right:BorderSide(color:ink,width:c==8?2:0),bottom:BorderSide(color:ink,width:r==8?2:0))),child:board[r][c]!=0?Text('${board[r][c]}',style:TextStyle(fontSize:18,fontWeight:fixed?FontWeight.bold:FontWeight.normal,color:wrong&&!fixed?rust:ink)):Text((notesMap['$r,$c']??{}).join(' '),style:const TextStyle(fontSize:7))));})),
 const SizedBox(height:10),const Text('Bir satırda, sütunda veya 3×3 alanda sayı tekrar etmez.'),Wrap(spacing:5,children:List.generate(9,(i)=>OutlinedButton(style:OutlinedButton.styleFrom(minimumSize:const Size(39,43),padding:EdgeInsets.zero),onPressed:()=>put(i+1),child:Text('${i+1}')))),
 Row(mainAxisAlignment:MainAxisAlignment.center,children:[TextButton.icon(onPressed:()=>put(0),icon:const Icon(Icons.backspace),label:const Text('Sil')),TextButton.icon(onPressed:()=>setState(()=>notes=!notes),icon:Icon(notes?Icons.edit_note:Icons.edit_outlined),label:Text('Not ${notes?'açık':'kapalı'}'))]),
 FilledButton(onPressed:check,child:const Text('Sudoku kontrol et')),
 ]);
}

const searchGrid=['KALEMXYZ','SUDOKUAB','GAZETECD','BULMACAE','TARIHFGH','IPUCUJKL','MNOPRSTU','VYZABCDE'];
const searchWords=['KALEM','SUDOKU','GAZETE','BULMACA','TARİH','İPUCU'];
// Grid ASCII karakterli olduğundan kelime karşılaştırması Türkçe I/İ varyantını normalize eder.
String normalize(String s)=>trUpper(s).replaceAll('İ','I').replaceAll('Ş','S').replaceAll('Ğ','G').replaceAll('Ü','U').replaceAll('Ö','O').replaceAll('Ç','C');
class SearchGame extends StatefulWidget {final VoidCallback onSolved;const SearchGame({super.key,required this.onSolved});@override State<SearchGame> createState()=>_SearchGameState();}
class _SearchGameState extends State<SearchGame>{
 (int,int)? start;Set<String> found={};Set<String> marked={};
 @override void initState(){super.initState();restore();}
 Future<void> restore()async{final s=await Store.read('search_found');if(s!=null&&mounted){setState(()=>found=s.split('|').where((x)=>x.isNotEmpty).toSet());}}
 void tap(int r,int c){if(start==null){setState(()=>start=(r,c));return;}final a=start!;setState(()=>start=null);final dr=r-a.$1,dc=c-a.$2;final stepR=dr.sign,stepC=dc.sign;if(dr!=0&&dc!=0&&dr.abs()!=dc.abs())return;final len=dr.abs()>dc.abs()?dr.abs()+1:dc.abs()+1;final chars=<String>[],ids=<String>[];for(var i=0;i<len;i++){final y=a.$1+i*stepR,x=a.$2+i*stepC;chars.add(searchGrid[y][x]);ids.add('$y,$x');}final word=chars.join(),reversed=chars.reversed.join();final match=searchWords.where((w)=>normalize(w)==normalize(word)||normalize(w)==normalize(reversed));if(match.isNotEmpty){setState((){found.add(match.first);marked.addAll(ids);});Store.write('search_found',found.join('|'));if(found.length==searchWords.length)widget.onSolved();}else{ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Bu yönde aranan kelime bulunamadı.')));}}
 @override Widget build(BuildContext context) {
 final paths = <String>{};
 for (final w in searchWords) {
   if (!found.contains(w)) {
     continue;
   }
   for (var r = 0; r < 8; r++) {
     for (var c = 0; c < 8; c++) {
       for (final dir in [(0, 1), (1, 0), (1, 1), (-1, 1)]) {
         final ids = <String>[];
         final letters = <String>[];
         for (var i = 0; i < w.length; i++) {
           final y = r + i * dir.$1;
           final x = c + i * dir.$2;
           if (y < 0 || y >= 8 || x < 0 || x >= 8) {
             break;
           }
           ids.add('$y,$x');
           letters.add(searchGrid[y][x]);
         }
         if (letters.length == w.length &&
             (normalize(letters.join()) == normalize(w) ||
              normalize(letters.reversed.join()) == normalize(w))) {
           paths.addAll(ids);
         }
       }
     }
   }
 }
 return Column(children:[const Text('Bir kelimenin ilk ve son harfine sırayla dokun. Yatay, dikey veya çapraz seçebilirsin.'),const SizedBox(height:14),AspectRatio(aspectRatio:1,child:GridView.builder(physics:const NeverScrollableScrollPhysics(),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:8),itemCount:64,itemBuilder:(ctx,i){final r=i~/8,c=i%8;return InkWell(onTap:()=>tap(r,c),child:Container(margin:const EdgeInsets.all(1),alignment:Alignment.center,color:start==(r,c)?rust:paths.contains('$r,$c')?const Color(0xFFC5D9B7):Colors.white,child:Text(searchGrid[r][c],style:TextStyle(fontWeight:FontWeight.bold,fontSize:19,color:start==(r,c)?Colors.white:ink))));})),const SizedBox(height:12),Wrap(spacing:8,runSpacing:8,children:searchWords.map((w)=>Chip(label:Text(w,style:TextStyle(decoration:found.contains(w)?TextDecoration.lineThrough:null)),backgroundColor:found.contains(w)?const Color(0xFFC5D9B7):Colors.white)).toList()),Text('${found.length}/${searchWords.length} kelime bulundu')]);}
}

// Sarmalın konumları dış kenardan başlayıp merkeze ilerler.
List<(int,int)> spiralPositions(int n){final result=<(int,int)>[];int top=0,left=0,bottom=n-1,right=n-1;while(top<=bottom&&left<=right){for(var c=left;c<=right;c++)result.add((top,c));top++;for(var r=top;r<=bottom;r++)result.add((r,right));right--;if(top<=bottom){for(var c=right;c>=left;c--)result.add((bottom,c));bottom--;}if(left<=right){for(var r=bottom;r>=top;r--)result.add((r,left));left++;}}return result;}
const spiralWords=[('KALEM','Yazmaya yarayan nesne'),('MASA','Üzerinde yemek yenir'),('ARABA','Tekerlekli taşıt'),('ANAHTAR','Kapıyı açar'),('RENK','Kırmızı, mavi, yeşil')];
class SpiralGame extends StatefulWidget{final VoidCallback onSolved;const SpiralGame({super.key,required this.onSolved});@override State<SpiralGame> createState()=>_SpiralGameState();}
class _SpiralGameState extends State<SpiralGame>{
 late final answer=spiralWords.map((e)=>e.$1).reduce((a,b)=>a+b.substring(1));
 final Map<int,String> entered={};int selected=0;late final positions=spiralPositions(5);
 @override void initState(){super.initState();restore();}
 Future<void> restore()async{final s=await Store.read('spiral');if(s!=null&&mounted){setState((){for(var i=0;i<s.length&&i<answer.length;i++){if(s[i]!='_')entered[i]=s[i];}});}}
  void put(String v){setState((){if(v=='_'){entered.remove(selected);}else{entered[selected]=v;if(selected<answer.length-1)selected++;}});Store.write('spiral',List.generate(answer.length,(i)=>entered[i]??'_').join());}
 void check(){final ok=List.generate(answer.length,(i)=>entered[i]==answer[i]).every((x)=>x);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(ok?'Sarmal çözüldü!':'Bazı harfler eksik veya yanlış.')));if(ok)widget.onSolved();}
 @override Widget build(BuildContext context){final at=<String,int>{};for(var i=0;i<answer.length;i++){at['${positions[i].$1},${positions[i].$2}']=i;}return Column(children:[const Text('1 numaralı dış kutudan başlayıp saat yönünde merkeze doğru ilerle. Her kelimenin son harfi sonraki kelimenin ilk harfidir.'),const SizedBox(height:14),AspectRatio(aspectRatio:1,child:GridView.builder(physics:const NeverScrollableScrollPhysics(),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5),itemCount:25,itemBuilder:(ctx,i){final r=i~/5,c=i%5,index=at['$r,$c'];return InkWell(onTap:index==null?null:()=>setState(()=>selected=index),child:Container(margin:const EdgeInsets.all(2),color:index==null?ink:index==selected?const Color(0xFFE6D4AF):Colors.white,child:index==null?null:Stack(children:[Positioned(left:3,top:2,child:Text('${index+1}',style:const TextStyle(fontSize:9,color:rust))),Center(child:Text(entered[index]??'',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)))])));})),
 const SizedBox(height:10),...spiralWords.map((e)=>Text('• ${e.$2} (${e.$1.length} harf)',style:const TextStyle(fontSize:13))),const SizedBox(height:10),Wrap(spacing:4,runSpacing:4,children:[...'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ'.split('').map((x)=>SizedBox(width:38,height:38,child:OutlinedButton(style:OutlinedButton.styleFrom(padding:EdgeInsets.zero),onPressed:()=>put(x),child:Text(x)))),IconButton(onPressed:()=>put('_'),icon:const Icon(Icons.backspace_outlined))]),const SizedBox(height:12),FilledButton(onPressed:check,child:const Text('Sarmalı kontrol et'))]);}
}

const pictureQuestions=[('🌞 + 🌻','GÜNEBAKAN','Güneşe yönelen çiçek'),('❄️ + 👨','KARDANADAM','Kışın kardan yapılan figür'),('🦷 + 🪥','DİŞ FIRÇASI','Dişleri temizlemek için kullanılır'),('🌊 + 🐴','DENİZATI','Denizde yaşayan küçük canlı')];
class PictureGame extends StatefulWidget {final VoidCallback onSolved;const PictureGame({super.key,required this.onSolved});@override State<PictureGame> createState()=>_PictureGameState();}
class _PictureGameState extends State<PictureGame>{
 int index=0;final ctrl=TextEditingController();bool hint=false;
 @override void initState(){super.initState();restore();}
 Future<void> restore()async{final x=await Store.read('picture_index');final n=int.tryParse(x??'')??0;if(mounted)setState(()=>index=n.clamp(0,pictureQuestions.length-1));}
 @override void dispose(){ctrl.dispose();super.dispose();}
 void check(){final q=pictureQuestions[index],a=normalize(ctrl.text.replaceAll(' ','')),b=normalize(q.$2.replaceAll(' ',''));if(a==b){if(index==pictureQuestions.length-1){widget.onSolved();ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Bütün resimli bulmacalar çözüldü!')));}else{setState((){index++;ctrl.clear();hint=false;});Store.write('picture_index','$index');}}else{ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Tekrar dene!')));}}
 @override Widget build(BuildContext context){final q=pictureQuestions[index];return Column(children:[Text('SORU ${index+1} / ${pictureQuestions.length}',style:const TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:12),Card(child:SizedBox(height:155,width:double.infinity,child:Center(child:Text(q.$1,style:const TextStyle(fontSize:60))))),const SizedBox(height:10),Text('${q.$2.replaceAll(' ','').length} harf'),if(hint)Text('İpucu: ${q.$3}',style:const TextStyle(color:rust)),const SizedBox(height:10),TextField(controller:ctrl,textCapitalization:TextCapitalization.characters,decoration:const InputDecoration(border:OutlineInputBorder(),labelText:'Cevabını yaz'),onSubmitted:(_)=>check()),const SizedBox(height:12),Row(children:[TextButton(onPressed:()=>setState(()=>hint=true),child:const Text('İpucu göster')),const Spacer(),FilledButton(onPressed:check,child:const Text('Kontrol et'))])]);}
}
