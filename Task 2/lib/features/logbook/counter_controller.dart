import 'package:shared_preferences/shared_preferences.dart';

enum ActivityType { increment, decrement, reset }
class CounterController {
  int counter = 0; 
  int _step = 1;
  
  final List<HistoryItem> _history = [];

  List<HistoryItem> get history => List.unmodifiable(_history);

  Future<void> saveLastValue(String username, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_counter_$username', value); // key unik per user
  }

  Future<int> loadLastValue(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_counter_$username') ?? 0; // default 0
  }

  Future<void> saveHistory(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStrings = _history.map((e) => "${e.message}|${e.type.index}").toList();
    await prefs.setStringList('history_$username', historyStrings);
  }

  Future<void> loadHistory(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> stored = prefs.getStringList('history_$username') ?? [];
    _history.clear();
    for (var s in stored) {
      var parts = s.split('|');
      _history.add(
        HistoryItem(
          message: parts[0],
          type: ActivityType.values[int.parse(parts[1])],
        ),
      );
    }
  }


  void changeStep(int newStep){
    if(newStep > 0){
      _step = newStep;
    }
  }

  void increment(String username) {
    counter += _step;
    _addHistory("User $username menambah $_step", ActivityType.increment);
    saveLastValue(username, counter); // simpan counter
    saveHistory(username);      
  } 

  void decrement(String username) { 
    if (counter > 0){
      counter -= _step;
      _addHistory("User $username mengurangi $_step", ActivityType.decrement);
    }
    if(counter < 0 ){
      counter = 0;
    }  
    saveLastValue(username, counter); // simpan counter
    saveHistory(username);      
  }

  void reset(String username) {
    counter = 0;
    _addHistory("User $username melakukan Reset ke 0", ActivityType.reset);
    saveLastValue(username, counter); // simpan counter
    saveHistory(username);      
  }


  void _addHistory(String action, ActivityType type) {
    final time =
        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    _history.add(HistoryItem(message: "$action pada $time", type: type));

    if (_history.length > 5) {
      _history.removeAt(0); 
    }
  }
} 

class HistoryItem {
  final String message;
  final ActivityType type;

  HistoryItem({
    required this.message,
    required this.type,
  });
}

