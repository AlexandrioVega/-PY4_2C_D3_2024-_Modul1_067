enum ActivityType { increment, decrement, reset }
class CounterController {
  int _counter = 0; 

  int get value => _counter;

  int _step = 1;
  
  final List<HistoryItem> _history = [];

  List<HistoryItem> get history => List.unmodifiable(_history);



  void increment(){
    _counter += _step;
    _addHistory("Menambah $_step", ActivityType.increment);
  } 

  void changeStep(int newStep){
    if(newStep > 0){
      _step = newStep;
    }
  }

  void decrement() { 
    if (_counter > 0){
      _counter -= _step;
      _addHistory("Mengurangi $_step", ActivityType.decrement);
    }
    if(_counter < 0 ){
      reset();
    }  
  }

  void reset(){
    _counter = 0;
    _addHistory("Reset ke 0", ActivityType.reset);
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

