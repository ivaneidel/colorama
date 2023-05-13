class GlobalState {
  static final GlobalState _singleton = GlobalState._internal();
  factory GlobalState() => _singleton;
  GlobalState._internal();

  static String? get userName => _singleton._userName;
  static int? get currentMatchId => _singleton._currentMatchId;
  static int? get r => _singleton._r;
  static int? get g => _singleton._g;
  static int? get b => _singleton._b;

  String? _userName;
  int? _currentMatchId;
  int? _r;
  int? _g;
  int? _b;

  static void setUserName(String name) => _singleton._userName = name;
  static void setCurrentMatchId(int id) => _singleton._currentMatchId = id;
  static void setR(int r) => _singleton._r = r;
  static void setG(int g) => _singleton._g = g;
  static void setB(int b) => _singleton._b = b;
}
