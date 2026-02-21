// ============================================================================
// Karakuri Fortune - Egyptian Calendar Oracle
//
// 実際のアプリ開発時には以下のパッケージを pubspec.yaml に追加し、
// KarakuriCore のモック部分を差し替えてください。
// dependencies:
//   shared_preferences: ^2.2.2
//   share_plus: ^7.2.1
// ============================================================================

import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const C());
}

// ----------------------------------------------------------------------------
// 1. CONSTANTS & DESIGN SYSTEM
// ----------------------------------------------------------------------------
class AppColors {
  static const spaceBg = Color(0xFF05070A);
  static const winBg = Color(0xD90A0F19);
  static const gold = Color(0xFFD4AF37);
  static const goldDim = Color(0xFF947A26);
  static const silver = Color(0xFFA0AAB5);
  static const textMain = Color(0xFFF4EDD8);
  static const textDim = Color(0xFF7A8A9E);
  static const carnelian = Color(0xFFC0392B);
  static const lapisLight = Color(0xFF3498DB);
  static const turquoise = Color(0xFF1ABC9C);
  static const whiteSkin = Color(0xFFF5F6FA);
  static const obsidian = Color(0xFF2C3E50);

  static Color getColorByClass(String cls) {
    switch (cls) {
      case 'c-gold':
        return gold;
      case 'c-blue':
        return lapisLight;
      case 'c-red':
        return carnelian;
      case 'c-turq':
        return turquoise;
      case 'c-white':
        return whiteSkin;
      case 'c-black':
        return obsidian;
      default:
        return gold;
    }
  }
}

class I18n {
  static const dict = {
    'ja': {
      'app_sub': "Egyptian Calendar Oracle",
      'app_title': "砂漠の星読儀",
      'app_desc': "古代エジプトの神々が司る365日の暦。\n生誕の刻を入力し、汝の守護神を呼び覚ませ。",
      'name_label': "名前 (任意 / Name)",
      'inp_name_ph': "名無し",
      'birth_label': "生誕の日 (Date of Birth)",
      'btn_calc': "神託を授かる",
      'res_sub': "ナイルの恩恵が導き出した、\n貴方の魂の設計図です。",
      'guardian_label': "主護神 / THE GUARDIAN",
      'talent_label': "✦ 隠された武器・天職",
      'compat_title': "神々の相関関係 (相性)",
      'compat_good': "共鳴する神 (運命の絆)",
      'compat_good_desc': "魂の波長が合い、共に素晴らしい創造を生み出せる相手。",
      'compat_chal': "試練の神 (学びの対象)",
      'compat_chal_desc': "価値観は異なるが、貴方に重要な気付きを与えてくれる相手。",
      'hook_title': "さらなる神託を解き放つ",
      'hook_desc': "Pro版で「前世からのカルマ」と「運命の転換期」を閲覧し、人生の羅針盤を完成させる",
      'btn_share': "神託を画像で保存・シェア",
      'btn_retry': "天球儀を巻き戻す",
      'prof_title': "PROFILES / 登録者一覧",
      'prof_empty': "まだ登録されていません。",
      'btn_match': "選んだ2人の相性を占う",
      'btn_back_prof': "一覧に戻る",
      'match_title': "DIVINE MATCH",
      'match_good': "最高の相性 (Destined Bond)",
      'match_chal': "試練の相性 (Challenging Bond)",
      'match_normal': "穏やかな相性 (Harmonious Bond)",
      'match_good_desc':
          "魂の波長が完璧に調和しています。互いの長所を引き出し合い、共に大きな創造を成し遂げることができるでしょう。",
      'match_chal_desc':
          "価値観の違いから衝突することもありますが、それは互いの魂を磨くための試練です。重要な気付きを与えてくれる関係です。",
      'match_normal_desc': "互いの違いを尊重し合える、穏やかで安定した関係です。焦らずゆっくりと絆を深めていくと良いでしょう。",
      'st_sec1': "1. データとエクスポート",
      'st_csv': "データをCSVで書き出す",
      'st_del': "すべてのデータを削除",
      'st_sec2': "2. アプリについて",
      'st_pro': "プレミアム (Pro) にアップグレード",
      'st_review': "アプリをレビューして応援する",
      'st_sec3': "3. 設定",
      'st_lang': "言語設定 (Language)",
      'st_haptics': "振動 (Haptics)",
      'pw_sub': "プレミアムへのアップグレード",
      'pw_f1': "隠された「前世からのカルマ」を解放",
      'pw_f2': "詳細な「運命の転換期」カレンダー",
      'pw_f3': "広告の完全非表示",
      'pw_btn1': "¥500 / 月ではじめる",
      'pw_btn2': "買い切り (Lifetime) ¥3,000",
      'pw_btn3': "今はしない",
      'loading_msg': "太陽の船が冥界を渡る...",
      'loading_sub': "INVOKING DEITIES",
    },
    'en': {
      'app_sub': "Karakuri Fortune",
      'app_title': "Desert Oracle",
      'app_desc':
          "The 365-day calendar ruled by ancient Egyptian gods.\nEnter your birth time and awaken your guardian.",
      'name_label': "Name (Optional)",
      'inp_name_ph': "Anonymous",
      'birth_label': "Date of Birth",
      'btn_calc': "Receive Oracle",
      'res_sub':
          "The blueprint of your soul,\nguided by the blessings of the Nile.",
      'guardian_label': "THE GUARDIAN",
      'talent_label': "✦ Hidden Talent / Vocation",
      'compat_title': "Divine Compatibility",
      'compat_good': "Resonant God (Destined Bond)",
      'compat_good_desc':
          "A soul match that inspires wonderful creations together.",
      'compat_chal': "Challenging God (Object of Learning)",
      'compat_chal_desc':
          "Different values, but provides crucial insights for you.",
      'hook_title': "Unlock Deeper Oracle",
      'hook_desc':
          "View 'Karma from Past Lives' and 'Turning Points of Fate' in the Pro version.",
      'btn_share': "Save & Share",
      'btn_retry': "Rewind Astrolabe",
      'prof_title': "SAVED PROFILES",
      'prof_empty': "No profiles saved yet.",
      'btn_match': "Check Compatibility",
      'btn_back_prof': "Back to Profiles",
      'match_title': "DIVINE MATCH",
      'match_good': "Destined Bond",
      'match_chal': "Challenging Bond",
      'match_normal': "Harmonious Bond",
      'match_good_desc':
          "Your soul frequencies are perfectly in harmony. You will bring out the best in each other.",
      'match_chal_desc':
          "Differences in values may cause friction, but it is a trial to polish each other's souls.",
      'match_normal_desc':
          "A calm and stable relationship where you can respect each other's differences.",
      'st_sec1': "1. Data & Export",
      'st_csv': "Export Data to CSV",
      'st_del': "Delete All Data",
      'st_sec2': "2. About App",
      'st_pro': "Upgrade to Premium (Pro)",
      'st_review': "Rate and Support Us",
      'st_sec3': "3. Settings",
      'st_lang': "Language",
      'st_haptics': "Haptics (Vibration)",
      'pw_sub': "Upgrade to Premium",
      'pw_f1': "Unlock hidden 'Karma from Past Lives'",
      'pw_f2': "Detailed 'Turning Points of Fate'",
      'pw_f3': "Completely remove ads",
      'pw_btn1': "Start at \$4.99 / mo",
      'pw_btn2': "Lifetime Unlock \$29.99",
      'pw_btn3': "Not Now",
      'loading_msg': "Crossing the Underworld...",
      'loading_sub': "INVOKING DEITIES",
    },
  };
}

// ----------------------------------------------------------------------------
// 2. CORE SYSTEM (KarakuriCore)
// ----------------------------------------------------------------------------
// 本来は shared_preferences を使いますが、単一ファイルでの動作テスト用に
// インメモリのモックストレージを用意しています。
class MockStorage {
  static final Map<String, String> _data = {};
  static String? getString(String key) => _data[key];
  static void setString(String key, String value) => _data[key] = value;
  static void remove(String key) => _data.remove(key);
}

class KarakuriCore extends ChangeNotifier {
  static final KarakuriCore instance = KarakuriCore._internal();
  KarakuriCore._internal();

  bool haptics = true;
  String lang = 'ja';
  final String historyKey = 'kf_egyptian_history';

  void init() {
    haptics = MockStorage.getString('kf_haptics') != 'false';
    lang = MockStorage.getString('kf_lang') ?? 'ja';
    notifyListeners();
  }

  String t(String key) => I18n.dict[lang]?[key] ?? key;

  void vibrate({String type = 'light'}) {
    if (!haptics) return;
    switch (type) {
      case 'light':
        HapticFeedback.lightImpact();
        break;
      case 'medium':
        HapticFeedback.mediumImpact();
        break;
      case 'heavy':
        HapticFeedback.heavyImpact();
        break;
      case 'success':
        HapticFeedback.vibrate();
        break; // 代用
      default:
        HapticFeedback.lightImpact();
    }
  }

  void toggleHaptics() {
    haptics = !haptics;
    MockStorage.setString('kf_haptics', haptics.toString());
    vibrate(type: 'medium');
    notifyListeners();
  }

  void toggleLang() {
    lang = lang == 'ja' ? 'en' : 'ja';
    MockStorage.setString('kf_lang', lang);
    vibrate(type: 'light');
    notifyListeners();
  }

  void track(String event, [Map<String, dynamic>? data]) {
    debugPrint('[Analytics] Tracked: $event');
  }

  void saveRecord(Profile record) {
    final str = MockStorage.getString(historyKey) ?? '[]';
    List<dynamic> history = jsonDecode(str);

    int idx = history.indexWhere((x) => x['id'] == record.id);
    final mapData = record.toMap();
    mapData['timestamp'] = DateTime.now().toIso8601String();

    if (idx >= 0) {
      history[idx] = mapData;
    } else {
      history.add(mapData);
    }

    MockStorage.setString(historyKey, jsonEncode(history));
    notifyListeners();
  }

  List<Profile> getProfiles() {
    final str = MockStorage.getString(historyKey) ?? '[]';
    List<dynamic> history = jsonDecode(str);
    return history.map((e) => Profile.fromMap(e)).toList().reversed.toList();
  }

  void clearData() {
    MockStorage.remove(historyKey);
    track('data_cleared');
    notifyListeners();
  }

  void exportCSV(BuildContext context) {
    vibrate(type: 'medium');
    track('export_csv_clicked');
    final profiles = getProfiles();
    if (profiles.isEmpty) {
      _showToast(context, lang == 'ja' ? "データがありません" : "No data available");
      return;
    }

    String csv = 'Name,Date,God_JP,God_EN,Timestamp\n';
    for (var p in profiles) {
      csv +=
          '${p.name},${p.dateLabel},${p.god.jp},${p.god.en},${p.timestamp}\n';
    }

    // share_plus パッケージの代わりにクリップボードコピーを使用
    Clipboard.setData(ClipboardData(text: csv));
    _showToast(
      context,
      lang == 'ja' ? "CSVをクリップボードにコピーしました" : "CSV copied to clipboard",
    );
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.spaceBg,
          ),
        ),
        backgroundColor: AppColors.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 3. MODELS & DATA
// ----------------------------------------------------------------------------
class God {
  final int id;
  final String jp, en, kw, desc, talent, colorClass;
  final List<List<int>> dates;

  God(
    this.id,
    this.jp,
    this.en,
    this.kw,
    this.desc,
    this.talent,
    this.colorClass,
    this.dates,
  );

  Map<String, dynamic> toMap() => {'id': id}; // 簡略化
  static God fromId(int id) =>
      godsData.firstWhere((g) => g.id == id, orElse: () => godsData.first);
}

class CompatResult {
  final String good, chal;
  final List<int> goodIds, chalIds;
  CompatResult(this.good, this.chal, this.goodIds, this.chalIds);
}

class Profile {
  final int id;
  final String name;
  final God god;
  final CompatResult compat;
  final String dateLabel;
  final String? timestamp;

  Profile({
    required this.id,
    required this.name,
    required this.god,
    required this.compat,
    required this.dateLabel,
    this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'godId': god.id,
    'dateLabel': dateLabel,
    'timestamp': timestamp,
  };

  static Profile fromMap(Map<String, dynamic> map) {
    final god = God.fromId(map['godId']);
    return Profile(
      id: map['id'],
      name: map['name'],
      god: god,
      compat: getCompat(god.id),
      dateLabel: map['dateLabel'],
      timestamp: map['timestamp'],
    );
  }
}

final List<God> godsData = [
  God(
    0,
    "ナイル",
    "The Nile",
    "豊穣・創造・癒し",
    "c-blue",
    "エジプトの生命線であるナイル川そのものを象徴します。あなたは平和を愛し、周囲に豊かさと癒しをもたらす存在です。情熱的で、目標に向かって真っ直ぐ進む強いエネルギーを秘めています。",
    "医療、カウンセラー、農業、インフラ構築など、人々に安らぎと基盤を与える仕事。",
    [
      [1, 1, 1, 7],
      [6, 19, 6, 28],
      [9, 1, 9, 7],
      [11, 18, 11, 26],
    ],
  ),
  God(
    1,
    "アメン・ラー",
    "Amun-Ra",
    "太陽・カリスマ・自信",
    "c-gold",
    "神々の王にして太陽神。強力なリーダーシップとカリスマ性を持ち、常に人々の中心に立ちます。自信に満ちており、困難な状況でも決して諦めない不屈の精神を持っています。",
    "経営者、政治家、プロジェクトリーダー、エンターテイナーなど、表舞台に立つ仕事。",
    [
      [1, 8, 1, 21],
      [2, 1, 2, 11],
    ],
  ),
  God(
    2,
    "ムト",
    "Mut",
    "母性・保護・論理的",
    "c-red",
    "世界を育む母なる女神。教育者としての素質があり、人々を保護し導く力があります。感情に流されず、論理的かつ現実的に物事を判断できる冷静さも持ち合わせています。",
    "教師、法律家、マネージャー、福祉関係など、人を守り育てる仕事。",
    [
      [1, 22, 1, 31],
      [9, 8, 9, 22],
    ],
  ),
  God(
    3,
    "ゲブ",
    "Geb",
    "大地・直感・信頼",
    "c-turq",
    "大地を司る神。優しく繊細で、他者の感情を敏感に察知する優れた直感力があります。信頼と誠実さを重んじ、周囲の平和と調和を保つバランサーとしての役割を果たします。",
    "心理学者、作家、環境保護活動、人事、サポート役。",
    [
      [2, 12, 2, 29],
      [8, 20, 8, 31],
    ],
  ),
  God(
    4,
    "オシリス",
    "Osiris",
    "再生・知性・情熱",
    "c-blue",
    "冥界と再生の神。古いものを壊し、新しく生まれ変わらせる力があります。知性が非常に高く、物事の表面だけでなく裏側まで見抜く鋭い洞察力を持っています。",
    "研究者、企業再生、投資家、探偵など、深い知識と分析を要する専門職。",
    [
      [3, 1, 3, 10],
      [11, 27, 12, 18],
    ],
  ),
  God(
    5,
    "イシス",
    "Isis",
    "魔法・愛・純粋",
    "c-white",
    "魔法と豊穣の女神。純粋な愛で人々を包み込み、奇跡を起こす力を持っています。ユーモアのセンスがあり、どんな困難な状況も持ち前の明るさで乗り越えられます。",
    "ウェディングプランナー、クリエイター、PR、人に夢を与える仕事。",
    [
      [3, 11, 3, 31],
      [10, 18, 10, 29],
      [12, 19, 12, 31],
    ],
  ),
  God(
    6,
    "トト",
    "Thoth",
    "知恵・記憶・コミュニケーション",
    "c-gold",
    "書記と知恵の神。卓越したコミュニケーション能力と、過去の教訓を活かす優れた記憶力を持ちます。常に新しい知識を吸収しようとする探求者であり、問題解決の天才です。",
    "ジャーナリスト、作家、エンジニア、情報伝達や執筆に関わる仕事。",
    [
      [4, 1, 4, 19],
      [11, 8, 11, 17],
    ],
  ),
  God(
    7,
    "ホルス",
    "Horus",
    "天空・勇気・先見の明",
    "c-blue",
    "天空の神。勇敢で正義感が強く、高い視点から物事の全体像を捉えることができます。リスクを恐れず、自らのビジョンを信じて未来を切り開く開拓者です。",
    "起業家、パイロット、コンサルタント、先を読む力と決断力が必要な仕事。",
    [
      [4, 20, 5, 7],
      [8, 12, 8, 19],
    ],
  ),
  God(
    8,
    "アヌビス",
    "Anubis",
    "冥界・守護・真実",
    "c-black",
    "死者の守護神。物事の真実を測る天秤のように、公平で冷静な判断力を持ちます。秘密を守る誠実な性格で、広く浅い交友よりも、深く狭い人間関係を好みます。",
    "裁判官、医師、経理、カウンセラーなど、正確さと秘密保持が求められる仕事。",
    [
      [5, 8, 5, 27],
      [6, 29, 7, 13],
    ],
  ),
  God(
    9,
    "セト",
    "Seth",
    "混沌・変化・完璧主義",
    "c-red",
    "嵐と混沌の神。現状に満足せず、常に変化と完璧を求める野心家です。強力なエネルギーを持ち、どんな障害をも打ち破る突破力とカリスマ性があります。",
    "営業職、アスリート、革新的なビジネスモデルの構築、ディレクター。",
    [
      [5, 28, 6, 18],
      [9, 28, 10, 2],
    ],
  ),
  God(
    10,
    "バステト",
    "Bastet",
    "喜び・芸術・神秘",
    "c-gold",
    "猫の女神。魅惑的で神秘的なオーラを放ち、芸術的なセンスに溢れています。直感に従って生きることを好み、ルールや束縛を極端に嫌う自由人です。",
    "デザイナー、アーティスト、美容関係、インフルエンサーなど感性を表現する仕事。",
    [
      [7, 14, 7, 28],
      [9, 23, 9, 27],
      [10, 3, 10, 17],
    ],
  ),
  God(
    11,
    "セクメト",
    "Sekhmet",
    "破壊と治癒・情熱・正義",
    "c-red",
    "雌ライオンの女神。圧倒的なパワーと正義感を持ち、曲がったことを許しません。破壊的な力を持つ一方で、傷ついた者を癒やす深い治癒の力も併せ持ちます。",
    "警察、外科医、指導者、困難な局面を打開するトラブルシューター。",
    [
      [7, 29, 8, 11],
      [10, 30, 11, 7],
    ],
  ),
];

CompatResult getCompat(int id) {
  final map = {
    0: {
      'good': [1, 9],
      'chal': [4, 6],
    },
    1: {
      'good': [0, 7],
      'chal': [5, 8],
    },
    2: {
      'good': [1, 6],
      'chal': [9, 10],
    },
    3: {
      'good': [9, 7],
      'chal': [4, 8],
    },
    4: {
      'good': [5, 6],
      'chal': [1, 7],
    },
    5: {
      'good': [4, 6],
      'chal': [8, 11],
    },
    6: {
      'good': [5, 10],
      'chal': [0, 3],
    },
    7: {
      'good': [1, 3],
      'chal': [4, 9],
    },
    8: {
      'good': [5, 10],
      'chal': [1, 3],
    },
    9: {
      'good': [0, 3],
      'chal': [2, 11],
    },
    10: {
      'good': [6, 11],
      'chal': [2, 9],
    },
    11: {
      'good': [10, 3],
      'chal': [0, 5],
    },
  };
  final ids =
      map[id] ??
      {
        'good': [0, 0],
        'chal': [1, 1],
      };
  final goodIds = ids['good']!;
  final chalIds = ids['chal']!;
  String goodStr =
      "${God.fromId(goodIds[0]).jp} / ${God.fromId(goodIds[1]).jp}";
  String chalStr =
      "${God.fromId(chalIds[0]).jp} / ${God.fromId(chalIds[1]).jp}";
  return CompatResult(goodStr, chalStr, goodIds, chalIds);
}

God getEgyptianGod(int m, int d) {
  for (final god in godsData) {
    for (final range in god.dates) {
      if (range.length == 4) {
        final m1 = range[0], d1 = range[1], m2 = range[2], d2 = range[3];
        if (m == m1 && m == m2 && d >= d1 && d <= d2)
          return god;
        else if (m == m1 && d >= d1)
          return god;
        else if (m == m2 && d <= d2)
          return god;
        else if (m > m1 && m < m2)
          return god;
      }
    }
  }
  return godsData[0];
}

String checkMatch(God g1, God g2) {
  final c1 = getCompat(g1.id);
  if (c1.goodIds.contains(g2.id)) return 'good';
  if (c1.chalIds.contains(g2.id)) return 'chal';
  final c2 = getCompat(g2.id);
  if (c2.goodIds.contains(g1.id)) return 'good';
  if (c2.chalIds.contains(g1.id)) return 'chal';
  return 'normal';
}

// ----------------------------------------------------------------------------
// 4. APP ENTRY & MAIN STATE
// ----------------------------------------------------------------------------
class KarakuriFortuneApp extends StatelessWidget {
  const KarakuriFortuneApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '砂漠の星読儀 | Karakuri Fortune',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.spaceBg,
        fontFamily: 'serif', // Webの 'Shippori Mincho B1' 相当
      ),
      home: const MainScreen(),
    );
  }
}

enum ScreenType { home, loader, result, profiles, match, settings }

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  ScreenType _currentScreen = ScreenType.home;
  Profile? _currentResult;
  List<int> _selectedMatchIds = [];

  // Background Animation
  late AnimationController _bgController;
  // Loader Animation
  late AnimationController _loaderController;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime(2000, 1, 1);

  // Modal states
  bool _showPaywall = false;
  bool _showReview = false;

  @override
  void initState() {
    super.initState();
    KarakuriCore.instance.init();
    KarakuriCore.instance.addListener(() => setState(() {}));
    KarakuriCore.instance.track('app_launched');

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _loaderController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _navigate(ScreenType screen) {
    setState(() => _currentScreen = screen);
  }

  Future<void> _startCalculation() async {
    KarakuriCore.instance.vibrate(type: 'medium');
    final name = _nameController.text.isNotEmpty
        ? _nameController.text
        : KarakuriCore.instance.t('inp_name_ph');

    final god = getEgyptianGod(_selectedDate.month, _selectedDate.day);
    final compat = getCompat(god.id);
    final monthNames = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    final dateLabel =
        "${monthNames[_selectedDate.month - 1]} ${_selectedDate.day.toString().padLeft(2, '0')}";

    _currentResult = Profile(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      god: god,
      compat: compat,
      dateLabel: dateLabel,
    );

    _navigate(ScreenType.loader);
    await Future.delayed(const Duration(seconds: 3));

    KarakuriCore.instance.track('oracle_calculated');
    KarakuriCore.instance.saveRecord(_currentResult!);
    KarakuriCore.instance.vibrate(type: 'success');
    _navigate(ScreenType.result);
  }

  // --------------------------------------------------------------------------
  // UI BUILDERS
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Canvas
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (_, __) =>
                  CustomPaint(painter: BgPainter(_bgController.value)),
            ),
          ),

          // Main Content with CrossFade
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildCurrentScreen(),
            ),
          ),

          // Top Navigation (Settings & Profiles)
          if (_currentScreen == ScreenType.home)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: Row(
                children: [
                  _buildIconButton('👥', () {
                    KarakuriCore.instance.vibrate();
                    _navigate(ScreenType.profiles);
                  }),
                  const SizedBox(width: 12),
                  _buildIconButton('⚙', () {
                    KarakuriCore.instance.vibrate();
                    _navigate(ScreenType.settings);
                  }),
                ],
              ),
            ),

          // Modals
          if (_showPaywall) _buildPaywallModal(),
          if (_showReview) _buildReviewModal(),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case ScreenType.home:
        return _buildHome();
      case ScreenType.loader:
        return _buildLoader();
      case ScreenType.result:
        return _buildResult();
      case ScreenType.profiles:
        return _buildProfiles();
      case ScreenType.match:
        return _buildMatch();
      case ScreenType.settings:
        return _buildSettings();
    }
  }

  Widget _buildIconButton(String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold),
        ),
        alignment: Alignment.center,
        child: Text(icon, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  // --- HOME SCREEN ---
  Widget _buildHome() {
    final core = KarakuriCore.instance;
    return Padding(
      key: const ValueKey('home'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            core.t('app_sub'),
            style: const TextStyle(
              fontFamily: 'serif',
              color: AppColors.gold,
              fontSize: 13,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            core.t('app_title'),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              shadows: [Shadow(color: Color(0x4DD4AF37), blurRadius: 15)],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            core.t('app_desc'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'sans-serif',
              color: AppColors.silver,
              fontSize: 13,
              height: 2.0,
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.winBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  core.t('name_label'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: core.t('inp_name_ph'),
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: Colors.black38,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  core.t('birth_label'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _selectedDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 24,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.gold),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: _startCalculation,
                  child: Text(
                    core.t('btn_calc'),
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- LOADER SCREEN ---
  Widget _buildLoader() {
    final core = KarakuriCore.instance;
    return Center(
      key: const ValueKey('loader'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _loaderController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.9 + (_loaderController.value * 0.2),
                child: Opacity(
                  opacity: 0.5 + (_loaderController.value * 0.5),
                  child: CustomPaint(
                    size: const Size(80, 80),
                    painter: PyramidPainter(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            core.t('loading_msg'),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.silver,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            core.t('loading_sub'),
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 10,
              color: AppColors.gold,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  // --- RESULT SCREEN ---
  Widget _buildResult() {
    if (_currentResult == null) return const SizedBox();
    final r = _currentResult!;
    final core = KarakuriCore.instance;
    final isJa = core.lang == 'ja';

    final oracleText = isJa
        ? "【${r.name}】の魂は、古代エジプトにおいて「${r.god.kw.split('・')[0]}」を司る『${r.god.jp}』の加護のもとに生まれました。\n\n本来備わっている「${r.god.talent.split('、')[0]}」という才能は、周囲の人々を導き、あるいは癒やす強力な武器となります。\n道に迷った時は、貴方に学びを与える『${r.compat.chal.split(' / ')[0]}』の性質を持つ人物との対話が、現状を打破する大きな鍵となるでしょう。"
        : "The soul of [${r.name}] was born under the protection of ${r.god.en}, who rules over ${r.god.kw.split('・')[0]}.\n\nYour inherent talent for ${r.god.talent.split('、')[0]} will serve as a powerful weapon to guide or heal others.\nWhen you lose your way, interacting with someone possessing the nature of ${r.compat.chal.split(' / ')[0]} will be the key to overcoming your current situation.";

    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              border: Border.all(color: AppColors.gold),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              r.dateLabel,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 16,
                color: AppColors.gold,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            core.t('res_sub'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.silver,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          // Main Card
          _buildGodCard(r.god),

          const SizedBox(height: 16),

          // Compat Card
          Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  core.t('compat_title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCompatItem(
                  core.t('compat_good'),
                  core.t('compat_good_desc'),
                  r.compat.good,
                  AppColors.lapisLight,
                ),
                const SizedBox(height: 12),
                _buildCompatItem(
                  core.t('compat_chal'),
                  core.t('compat_chal_desc'),
                  r.compat.chal,
                  AppColors.carnelian,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1, thickness: 1),
          const SizedBox(height: 24),

          // Oracle
          Text(
            "PAPYRUS ORACLE",
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 13,
              color: AppColors.gold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            oracleText,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMain,
              height: 2.2,
            ),
          ),

          const SizedBox(height: 32),

          // Premium Hook
          GestureDetector(
            onTap: () => setState(() => _showPaywall = true),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('🔒', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(
                    core.t('hook_title'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    core.t('hook_desc'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDim,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.spaceBg,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              // Share Text
              core.vibrate();
              core.track('text_share_clicked');
              final text = isJa
                  ? "【砂漠の星読儀】\n${r.name}の守護神は「${r.god.jp}」でした。\n✦ 性質: ${r.god.kw}\n✦ 共鳴する神: ${r.compat.good}\n#KarakuriFortune"
                  : "[Desert Oracle]\n${r.name}'s guardian is ${r.god.en}.\n✦ ${r.god.kw}\n✦ Bond: ${r.compat.good}\n#KarakuriFortune";
              Clipboard.setData(ClipboardData(text: text));
              core._showToast(
                context,
                isJa ? 'クリップボードにコピーしました' : 'Copied to clipboard',
              );
            },
            child: Text(
              core.t('btn_share'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textDim,
              side: const BorderSide(color: AppColors.textDim),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              core.vibrate();
              _navigate(ScreenType.home);
            },
            child: Text(
              core.t('btn_retry'),
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => setState(() => _showPaywall = true),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textDim,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "[ AdMob Mock ]\nTap to Upgrade and Remove Ads",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDim, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGodCard(God god) {
    final core = KarakuriCore.instance;
    final isJa = core.lang == 'ja';
    final mainColor = AppColors.getColorByClass(god.colorClass);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCC0F141E),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: const Size(140, 140),
                painter: GodIconPainter(god.id, mainColor, true),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            core.t('guardian_label'),
                            style: const TextStyle(
                              fontFamily: 'sans-serif',
                              fontSize: 11,
                              color: AppColors.textDim,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isJa ? god.jp : god.en,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      size: const Size(50, 50),
                      painter: GodIconPainter(god.id, mainColor, false),
                    ),
                  ],
                ),
                Text(
                  isJa ? god.en : god.jp,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 13,
                    color: AppColors.silver,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    god.kw,
                    style: TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 12,
                      color: mainColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  god.desc,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.8,
                    color: Color(0xFFDCDCDC),
                  ),
                ),

                const SizedBox(height: 20),
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 16),

                Text(
                  core.t('talent_label'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  god.talent,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatItem(
    String label,
    String desc,
    String val,
    Color valColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textDim,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            val,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valColor,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  // --- PROFILES SCREEN ---
  Widget _buildProfiles() {
    final core = KarakuriCore.instance;
    final profiles = core.getProfiles();

    return Padding(
      key: const ValueKey('profiles'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Row(
            children: [
              _buildIconButton('←', () {
                core.vibrate();
                _navigate(ScreenType.home);
              }),
              const Expanded(
                child: Text(
                  'PROFILES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'serif',
                    color: AppColors.gold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: profiles.isEmpty
                ? Center(
                    child: Text(
                      core.t('prof_empty'),
                      style: const TextStyle(color: AppColors.textDim),
                    ),
                  )
                : ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, i) {
                      final p = profiles[i];
                      final isSelected = _selectedMatchIds.contains(p.id);
                      return GestureDetector(
                        onTap: () {
                          core.vibrate();
                          setState(() {
                            if (isSelected)
                              _selectedMatchIds.remove(p.id);
                            else {
                              if (_selectedMatchIds.length >= 2)
                                _selectedMatchIds.removeAt(0);
                              _selectedMatchIds.add(p.id);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.gold.withOpacity(0.1)
                                : const Color(0x990F141E),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.gold
                                  : Colors.white10,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CustomPaint(
                                size: const Size(40, 40),
                                painter: GodIconPainter(
                                  p.god.id,
                                  AppColors.getColorByClass(p.god.colorClass),
                                  false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      core.lang == 'ja' ? p.god.jp : p.god.en,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.gold,
                                        fontFamily: 'serif',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: AppColors.textDim,
                                ),
                                onPressed: () {
                                  core.vibrate();
                                  setState(() {
                                    _currentResult = p;
                                    _currentScreen = ScreenType.result;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.spaceBg,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => _selectedMatchIds.length == 2
                        ? AppColors.gold
                        : AppColors.gold.withOpacity(0.5),
                  ),
                ),
            onPressed: _selectedMatchIds.length == 2
                ? () {
                    core.vibrate();
                    core.track('match_executed');
                    _navigate(ScreenType.match);
                  }
                : null,
            child: Text(
              core.t('btn_match'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- MATCH SCREEN ---
  Widget _buildMatch() {
    final core = KarakuriCore.instance;
    final profiles = core.getProfiles();
    if (_selectedMatchIds.length != 2) return const SizedBox();

    final p1 = profiles.firstWhere((p) => p.id == _selectedMatchIds[0]);
    final p2 = profiles.firstWhere((p) => p.id == _selectedMatchIds[1]);

    final matchType = checkMatch(p1.god, p2.god);
    final title = core.t('match_$matchType');
    final desc = core.t('match_${matchType}_desc');

    return Padding(
      key: const ValueKey('match'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Row(
            children: [
              _buildIconButton('←', () {
                core.vibrate();
                _navigate(ScreenType.profiles);
              }),
              Expanded(
                child: Text(
                  core.t('match_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    color: AppColors.gold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 40),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xCC0F141E),
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMatchPerson(p1),
                const Text(
                  '×',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.silver,
                    fontFamily: 'serif',
                  ),
                ),
                _buildMatchPerson(p2),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMain,
              height: 2.0,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textDim,
              side: const BorderSide(color: AppColors.textDim),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              core.vibrate();
              _navigate(ScreenType.profiles);
            },
            child: Text(
              core.t('btn_back_prof'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchPerson(Profile p) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          CustomPaint(
            size: const Size(60, 60),
            painter: GodIconPainter(
              p.god.id,
              AppColors.getColorByClass(p.god.colorClass),
              false,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            p.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            KarakuriCore.instance.lang == 'ja' ? p.god.jp : p.god.en,
            style: const TextStyle(fontSize: 11, color: AppColors.gold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- SETTINGS SCREEN ---
  Widget _buildSettings() {
    final core = KarakuriCore.instance;
    return Padding(
      key: const ValueKey('settings'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconButton('←', () {
                core.vibrate();
                _navigate(ScreenType.home);
              }),
              const Expanded(
                child: Text(
                  'SETTINGS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'serif',
                    color: AppColors.gold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 40),

          _buildSettingsSection(core.t('st_sec1'), [
            _buildSettingItem(
              core.t('st_csv'),
              '📄',
              onTap: () => core.exportCSV(context),
            ),
            _buildSettingItem(
              core.t('st_del'),
              '🗑️',
              color: AppColors.carnelian,
              onTap: () {
                core.vibrate(type: 'heavy');
                core.clearData();
                core._showToast(context, "Deleted");
              },
            ),
          ]),

          _buildSettingsSection(core.t('st_sec2'), [
            _buildSettingItem(
              core.t('st_pro'),
              '✨',
              color: AppColors.gold,
              onTap: () {
                core.vibrate();
                setState(() => _showPaywall = true);
              },
            ),
            _buildSettingItem(
              core.t('st_review'),
              '⭐',
              onTap: () {
                core.vibrate();
                setState(() => _showReview = true);
              },
            ),
          ]),

          _buildSettingsSection(core.t('st_sec3'), [
            _buildSettingItem(
              core.t('st_lang'),
              core.lang.toUpperCase(),
              onTap: () => core.toggleLang(),
            ),
            _buildSettingItem(
              core.t('st_haptics'),
              core.haptics ? 'ON' : 'OFF',
              onTap: () => core.toggleHaptics(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.gold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String label,
    String trailing, {
    Color color = AppColors.textMain,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0x990F141E),
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: color)),
            Text(trailing, style: TextStyle(fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }

  // --- MODALS ---
  Widget _buildReviewModal() {
    final core = KarakuriCore.instance;
    return _buildModalOverlay(
      child: _buildModalCard(
        color: AppColors.gold,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⭐⭐⭐⭐⭐', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 16),
            Text(
              core.t('md_rev_title'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              core.t('md_rev_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDim,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.spaceBg,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                core.vibrate(type: 'light');
                setState(() => _showReview = false);
                core._showToast(context, "Thanks!");
              },
              child: Text(
                core.t('md_rev_btn1'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                core.vibrate();
                setState(() => _showReview = false);
              },
              child: Text(
                core.t('md_rev_btn2'),
                style: const TextStyle(color: AppColors.textDim),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaywallModal() {
    final core = KarakuriCore.instance;
    return _buildModalOverlay(
      child: _buildModalCard(
        color: AppColors.gold,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Karakuri Fortune Pro',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 24,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              core.t('pw_sub'),
              style: const TextStyle(fontSize: 11, letterSpacing: 2),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckItem(core.t('pw_f1')),
                _buildCheckItem(core.t('pw_f2')),
                _buildCheckItem(core.t('pw_f3')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.spaceBg,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                core.vibrate(type: 'success');
                setState(() => _showPaywall = false);
                core._showToast(context, "Pro Enabled (Mock)");
              },
              child: Text(
                core.t('pw_btn1'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              core.t('pw_btn2'),
              style: const TextStyle(fontSize: 11, color: AppColors.textDim),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                core.vibrate();
                setState(() => _showPaywall = false);
              },
              child: Text(
                core.t('pw_btn3'),
                style: const TextStyle(color: AppColors.textDim, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text('✓', style: TextStyle(color: AppColors.gold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalOverlay({required Widget child}) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _buildModalCard({required Color color, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.winBg,
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -32,
            top: -32,
            bottom: -32,
            width: 4,
            child: Container(color: color),
          ),
          child,
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 5. PAINTERS (Canvas Animations)
// ----------------------------------------------------------------------------
class BgPainter extends CustomPainter {
  final double time;
  BgPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.gold.withOpacity(0.4);

    // Particles (Stars/Sand)
    for (int i = 0; i < 40; i++) {
      final px = (math.sin(i * 123 + time * 10) * 0.5 + 0.5) * size.width;
      final py = (math.cos(i * 321 + time * 15) * 0.5 + 0.5) * size.height;
      final baseS = (math.sin(i + time * 200) * 0.5 + 0.5) * 1.5;
      final twinkle = math.sin(time * 500 + i * 10) * 0.5 + 0.5;

      paint.color = AppColors.gold.withOpacity(0.2 + 0.8 * twinkle);
      canvas.drawCircle(Offset(px, py), baseS, paint);
    }

    // Abstract Sun/Moon
    final cx = size.width / 2;
    final cy = size.height / 2 - 80;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(time * 50);

    final linePaint = Paint()
      ..color = AppColors.gold.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(Offset.zero, 100.0 * i, linePaint);
    }

    linePaint.color = AppColors.gold.withOpacity(0.1);
    for (int i = 0; i < 3; i++) {
      canvas.rotate((math.pi * 2) / 3);
      final path = Path()
        ..moveTo(0, -150)
        ..lineTo(130, 75)
        ..lineTo(-130, 75)
        ..close();
      canvas.drawPath(path, linePaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BgPainter oldDelegate) => true;
}

class PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final eyePaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.3), 5, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GodIconPainter extends CustomPainter {
  final int id;
  final Color color;
  final bool isBg;

  GodIconPainter(this.id, this.color, this.isBg);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isBg ? 4 : 2
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(cx, cy);

    switch (id % 4) {
      case 0:
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: r * 2, height: r),
          paint,
        );
        canvas.drawCircle(Offset.zero, r * 0.2, fillPaint);
        if (isBg)
          canvas.drawArc(
            Rect.fromCircle(center: Offset.zero, radius: r * 0.8),
            math.pi,
            math.pi,
            false,
            paint,
          );
        break;
      case 1:
        canvas.drawCircle(Offset.zero, r * 0.5, paint);
        for (int i = 0; i < 8; i++) {
          canvas.rotate(math.pi / 4);
          canvas.drawLine(Offset(0, r * 0.6), Offset(0, r), paint);
        }
        break;
      case 2:
        final path = Path()
          ..moveTo(0, -r)
          ..lineTo(r * 0.8, r * 0.6)
          ..lineTo(-r * 0.8, r * 0.6)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawLine(Offset(0, -r), Offset(0, r * 0.6), paint);
        break;
      case 3:
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(0, -r * 0.3),
            width: r * 0.6,
            height: r * 0.8,
          ),
          paint,
        );
        canvas.drawLine(
          Offset(-r * 0.5, r * 0.1),
          Offset(r * 0.5, r * 0.1),
          paint,
        );
        canvas.drawLine(Offset(0, r * 0.1), Offset(0, r * 0.8), paint);
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GodIconPainter oldDelegate) =>
      oldDelegate.id != id || oldDelegate.color != color;
}
