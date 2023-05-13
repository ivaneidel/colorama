class GlobalState {
  static final GlobalState _singleton = GlobalState._internal();
  factory GlobalState() => _singleton;
  GlobalState._internal();

  static String? get userName => _singleton._userName;
  static int? get currentMatchId => _singleton._currentMatchId;

  String? _userName;
  int? _currentMatchId;

  static void setUserName(String name) => _singleton._userName = name;
  static void setCurrentMatchId(int id) => _singleton._currentMatchId = id;
}
